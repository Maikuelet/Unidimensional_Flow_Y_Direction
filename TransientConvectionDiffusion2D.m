%TRANSIENT 2-D CONVECTION-DIFFUSSION EQUATION
%------------------------------------------------

classdef TransientConvectionDiffusion2D < handle
    
    properties (SetAccess=public)
        mesh, physProp,boundCond ,timeStep, refTime , coef, Prop,Pref, err
    end
    
    %Prop = property to compute
    
    methods
        
        function  obj = TransientConvectionDiffusion2D(mesh, physProp, boundCond, timeStep, initProp, refTime)
            obj.mesh=mesh;
            obj.physProp=physProp;
            obj.boundCond=boundCond;            
            obj.timeStep=timeStep;
            obj.refTime = refTime;
            
            obj.Prop = Properties(mesh, initProp); 
            obj.coef = Coefficients(obj.mesh);
            
            
            
        end
        
        
        %Main function
        function solveTime(obj, maxIter, maxDiff,PostProcess,maxtDiff,Pe)            
            
            
            %CONSTANT COEFFICIENTS
            %-----------------------------------------------------------------------
            %Inner matrix
            obj.coef.innerAfor(obj.physProp,obj.mesh,obj.timeStep, obj.Prop);  
            
            
            %Boundaries
            obj.coef.topBoundary(obj.Prop);   
            obj.coef.leftBoundary(obj.boundCond.leftProp, obj.Prop);      
            obj.coef.bottomBoundary(obj.Prop);
            obj.coef.rightBoundary(obj.boundCond.rightProp,obj.Prop);
    
                     
        
            %MAIN ALGORITHM
            %------------------------------------------------------------------------          
            obj.Prop.T0 = obj.Prop.T;
            obj.Prop.Tt = obj.Prop.T;
            Time = zeros;               %Iteration time
            time = zeros;                   %Real time
            Error = zeros;
            
            obj.err = zeros (size(obj.coef.ap,1)-1,size(obj.coef.ap,2)-1)+1;
            tit = 0;                     %Time iterations
            
            %CORE OF THE CODE
            %--------------------------------------------------------------
            diff2=inf;
            tic;
            
            while diff2 > maxtDiff
                
                tit = tit +1;        %Time iteration count
                time(tit) = tit*obj.timeStep;
                
                %INNER COEFFICIENTS
                %------------------
                obj.coef.innerAforTime(obj.mesh,obj.timeStep,obj.Prop);
                         
                %DOMAIN CONVERGENCE
                %-----------------               
                it = 0;                
                diff1=inf;
                stop=0;
                
                while (diff1 > maxDiff)  || stop == 1
                    
                    it = it +1;
                    
                    %SOLVER 
                    %-----------------
                    Solver(obj.coef, obj.Prop);                                    
                    
                    % CONVERGENCE CHECK
                    %-----------------                           
                    obj.err = abs(obj.Prop.T0-obj.Prop.T);
                    a = max(obj.err);
                    diff1 = max(a);

                    obj.Prop.T0 = obj.Prop.T;   
                    
                    if it > maxIter
                        error("Can not reach convergence of the results, check Input Data")
                        stop=1;
                    end                    
                end  
                
                d2 = abs(obj.Prop.Tt-obj.Prop.T);
                d2i = max(d2);
                diff2 = max(d2i);%/obj.timeStep;
                obj.Prop.Tt=obj.Prop.T; 
                Time(tit) = toc; 
                
                %Auxiliar Information
                fprintf('Time= %d; Ctime = %d;  Error = %d;  Iterations = %d; TimeStep = %d\n',...
                            time(tit),Time(tit),diff2,it,tit);
                
                Error(tit) = diff2;
                
                %Postproces Evolutive Plot
                if PostProcess == 11
                    o = rot90(obj.Prop.T,-1);
                    O=fliplr(o);
                    figure(3);
                    pcolor(obj.mesh.nodeX,obj.mesh.nodeY,O);
                    shading interp; 
                    colormap(jet);
                    colorbar;
                    title('Field \phi ');
                    xlabel('x'), ylabel('y');                    
                end
               
                
                
            end
            
            if PostProcess ==1
                
                postprocess(obj.Prop, obj.mesh);
                
                
                %---------- 3-D FIELD PLOT ---------%
                o = rot90(obj.Prop.T,-1);
                O=fliplr(o);
                figure(5)
                mesh(obj.mesh.nodeX,rot90(obj.mesh.nodeY,-2),rot90(o,-2));
                colormap(jet);
                title('Field \phi ');
                xlabel('Domain size (x)'), ylabel('Domain size (y)');
                zlabel('Field \phi value');
                
                % -------- ANALYTIC VS SIMULATION PLOT ----------%
                sizeX=size(obj.coef.ap,1);
                vals=zeros(sizeX,1);
                y=zeros(sizeX,1);
                
                for indPX=1:sizeX
                    vals(indPX)=obj.Prop.T(indPX,1);
                    
                    %Analytic Solution
                    L = obj.mesh.nodeX(end)-obj.mesh.nodeX(1);
                    y(indPX)=(obj.boundCond.rightProp-obj.boundCond.leftProp)*obj.mesh.nodeX(indPX)/L + obj.boundCond.leftProp;  
                end
               
                x= linspace(obj.mesh.nodeX(1),obj.mesh.nodeX(end),sizeX);
                
                figure(6) 
                p=plot(x,vals, x,y);
                title('Field \phi ');
                xlabel('Domain size (x)'), ylabel('Field \phi Value');
                ylim([min(vals) max(vals)+5]);
                p(1).LineWidth = 2;
                P(2).LineWidth = 2;                
                legend({'Calculated Solution','Analytic Solution'},'Location','northwest')
            end
        end      
                
    end
    
    
    
end

%---------------------------------------------------%
%---------------POSTPROCESSOR FUNCTION--------------%
%---------------------------------------------------%
function postprocess(Prop, mesh)
            
            
    o = rot90(Prop.T,-1);
    O=fliplr(o);

    % ------------ISOTHERM MAP -------------%
    figure(1);          
    contour(O);     
    colormap(jet);
    colorbar;
    title('Field \phi isobars ');
    xlabel('x'), ylabel('y');

    %---------ISOTHERM COLOR MAP ---------%
    figure(2);                     
    contourf(mesh.nodeX,mesh.nodeY,O);     %mostra les isotermes
    colormap(jet);
    colorbar;
    title('Field \phi isobars ');
    xlabel('x'), ylabel('y');

    % -------------COLOR MAP --------------%
    figure(3);
    pcolor(mesh.nodeX,mesh.nodeY,O);
    shading interp; 
    colormap(jet);
    colorbar;
    title('Field \phi ');
    xlabel('x'), ylabel('y');



    %-----------  MESH PLOT ----------------%
    figure(4);            
    h = heatmap(rot90(o,-2));  %heatmap
    colormap(jet);            
    title('Field \phi ');
    xlabel('Nodes in x direction'), ylabel('Nodes in y direction');
            
 end
