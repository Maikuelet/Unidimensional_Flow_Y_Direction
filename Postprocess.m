% POSTPROCESSING TOOLS
%-------------------------------------------------

classdef Postprocess < handle
    properties  (SetAccess = public)
           vals  
    end 
    
    methods 
        function obj = Postprocess(Prop, mesh)
            
                      
            o = rot90(Prop.T,-1);
            O=fliplr(o);

            % ------------ISOTHERM MAP -------------%
            figure(1);          
            contour(O);     
            colormap(jet);
            colorbar;
            title('Field \phi isobars of the Smith-Hutton Problem');
            xlabel('x'), ylabel('y');

            %---------ISOTHERM COLOR MAP ---------%
            figure(2);                     
            contourf(mesh.nodeX,mesh.nodeY,O);     %mostra les isotermes
            colormap(jet);
            colorbar;
            title('Field \phi isobars of the Smith-Hutton Problem');
            xlabel('x'), ylabel('y');

            % -------------COLOR MAP --------------%
            figure(3);
            pcolor(mesh.nodeX,mesh.nodeY,O);
            shading interp; 
            colormap(jet);
            colorbar;
            title('Field \phi of the Smith-Hutton Problem');
            xlabel('x'), ylabel('y');



            %-----------  MESH PLOT ----------------%
            figure(4);            
            h = heatmap(rot90(o,-2));  %heatmap
            colormap(jet);            
            title('Field \phi of the Smith-Hutton Problem');
            xlabel('Nodes in x direction'), ylabel('Nodes in y direction');


            %---------- 3-D FIELD PLOT ---------%
%             figure(5)
%             mesh(mesh.nodeX,rot90(mesh.nodeY,-2),rot90(o,-2));
%             colormap(jet);
%             title('Field \phi of the Smith-Hutton Problem');
%             xlabel('Domain size (x)'), ylabel('Domain size (y)');
%             zlabel('Field \phi value');

            % -------- INLET AND OUTLET FIELD PLOT ----------%
            sizeX=size(mesh.nodeX,1);
            vals = zeros(sizeX-1);
            for indPX=2:sizeX
                vals(indPX-1)=Prop.T(indPX,2);
            end

            x=linspace(-1,1,sizeX-1);

            figure(6)
            y= zeros(sizeX-1)+  max(vals);    
            p=plot(x,vals, x,y,'--k','LineWidth',1);
            title('Field \phi of the Smith-Hutton Problem at Bottom Boundary');
            xlabel('Domain size (x)'), ylabel('Field \phi Value');

            ylim([min(vals) max(vals)+1]);
            p(1).LineWidth = 2;

            
                        
        end
    end
end