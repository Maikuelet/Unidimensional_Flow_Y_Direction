classdef Coefficients < handle
  properties (SetAccess=private)
    ap, ae, aw, an, as, ap0, b, Fe
  end
  methods
    function obj = Coefficients(mesh)
      obj.ap=zeros(numel(mesh.nodeX),numel(mesh.nodeY));
      obj.ap0=zeros(size(obj.ap));
      obj.ae=zeros(size(obj.ap));
      obj.aw=zeros(size(obj.ap));
      obj.an=zeros(size(obj.ap));
      obj.as=zeros(size(obj.ap));
      obj.b=zeros(size(obj.ap));        
      obj.Fe=zeros(size(obj.ap));        

    end 
  
    
    %INNER MATRIX COEFFICIENTS
    %---------------------------    
    function innerAfor(obj,physProp,mesh,timeStep,Prop)
      
      sizeX=size(obj.ap,1);
      sizeY=size(obj.ap,2);
      
      for indPX=2:sizeX-1
        for indPY=2:sizeY-1
          
          Se= (mesh.faceY(indPY)-mesh.faceY(indPY-1));
          Sw= Se;
          Sn= (mesh.faceX(indPX)-mesh.faceX(indPX-1));
          Ss= Sn;
                      
          obj.Fe(indPX,indPY) = Se*physProp.rho(indPX+1,indPY)*mesh.Uf(indPX,indPY);  
          Fw = Sw*physProp.rho(indPX-1,indPY)*mesh.Uf(indPX - 1,indPY);  
          Fn = Sn*physProp.rho(indPX,indPY+1)*mesh.Vf(indPX,indPY); 
          Fs = Ss*physProp.rho(indPX,indPY-1)*mesh.Vf(indPX,indPY - 1);   
          
                 
          De = ((physProp.rho(indPX+1,indPY)/physProp.rhogamma(indPX,indPY))*Se)/...
               (mesh.nodeX(indPX+1) - mesh.nodeX(indPX));
          Dw = ((physProp.rho(indPX-1,indPY)/physProp.rhogamma(indPX,indPY))*Sw)/...
               (mesh.nodeX(indPX) - mesh.nodeX(indPX-1));
          Dn=  ((physProp.rho(indPX,indPY+1)/physProp.rhogamma(indPX,indPY))*Sn)/...
               (mesh.nodeY(indPY+1) - mesh.nodeY(indPY));
          Ds=  ((physProp.rho(indPX,indPY-1)/physProp.rhogamma(indPX,indPY))*Ss)/...
               (mesh.nodeY(indPY) - mesh.nodeY(indPY-1));          
          
          
          %NUMERICAL SCHEME POWERLAW          
          Ae =1;% max(0, (1-0.1*abs(Pe))^5);
          Aw =1;% max(0, (1-0.1*abs(Pw))^5);
          An =1;% max(0, (1-0.1*abs(Pn))^5);
          As =1;% max(0, (1-0.1*abs(Ps))^5);
          
          obj.ae(indPX,indPY)= De*Ae + max(-obj.Fe(indPX,indPY),0);
          obj.aw(indPX,indPY)= Dw*Aw + max(Fw,0);
          obj.an(indPX,indPY)= Dn*An + max(-Fn,0);
          obj.as(indPX,indPY)= Ds*As + max(Fs,0);
          
          obj.ap0(indPX,indPY)=Se*Sn*Prop.T(indPX,indPY)/timeStep;
          
          obj.ap(indPX,indPY) = obj.ap0(indPX,indPY)+obj.ae(indPX,indPY)+...
          obj.as(indPX,indPY)+obj.an(indPX,indPY)+obj.aw(indPX,indPY);
          
          %Same as function newInnerB
          obj.b(indPX,indPY) = obj.ap0(indPX,indPY)*Prop.T(indPX,indPY);        
          
        end
      end
    end
    
    %INNER MATRIX TIME DEPENDENT COEFFICIENTS
    %-------------------------------------------
    %-Density = ct
    %-Velocity field = ct
    function innerAforTime(obj,mesh,timeStep,Prop)
        
        sizeX=size(obj.ap,1);
        sizeY=size(obj.ap,2);
        
        %Neuman Boundary Condition
        
        for indPX=1:sizeX              
                
            Prop.T(indPX , 1) =  Prop.T(indPX,2);        
            Prop.T(indPX , end) =  Prop.T(indPX,end-1);     
        end
        
 
     
        
      
         for indPX=2:sizeX-1
            for indPY=2:sizeY-1
                
                Se= (mesh.faceY(indPY)-mesh.faceY(indPY-1));
                Sw= Se;
                Sn= (mesh.faceX(indPX)-mesh.faceX(indPX-1));
                Ss= Sn;
                
                obj.ap0(indPX,indPY)=(Se*Sn*Prop.T(indPX,indPY))/timeStep;
          
                obj.ap(indPX,indPY) = obj.ap0(indPX,indPY)+obj.ae(indPX,indPY)+...
                    obj.as(indPX,indPY)+obj.an(indPX,indPY)+obj.aw(indPX,indPY);
          
                obj.b(indPX,indPY) = obj.ap0(indPX,indPY)*Prop.T(indPX,indPY);
                                
            end             
         end         
    end
    
    function newInnerB(obj,Prop)
      obj.b(2:end-1,2:end-1)=obj.ap0(2:end-1,2:end-1).*Prop.T(2:end-1,2:end-1);
    end
    
    
    %BOUNDARY COEFFICIENTS
    %------------------------------------------------

    function topBoundary(obj,Prop)        
 
      sizeX=size(obj.ap,1);
  
               
        for indPX=2:sizeX-1
          Prop.T(indPX , end) =  Prop.T(indPX,end-1);      
        end
      
    end    
    
    function bottomBoundary(obj,Prop)
        
        sizeX=size(obj.ap,1);
  
               
        for indPX=2:sizeX-1
          Prop.T(indPX , 1) =  Prop.T(indPX,2);      
        end
        
    end
    
    function leftBoundary(obj,leftProp,Prop)
          
      Prop.T(1,1:end) = leftProp;
      
    end
    
    function rightBoundary(obj, rightProp, Prop)
      Prop.T(end,2:end) = rightProp;
    end
    
  end
end
