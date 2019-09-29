%UNIFOR MESH & VELOCITY FIELD GENERATION 
%------------------------------------------

classdef UniformMesh < handle
  properties (SetAccess=private)
    nodeX, nodeY, faceX, faceY, domain, U, V, Uf, Vf
  end
  methods
        
    function obj = UniformMesh(domainPoints,meshSizes,v0)
        
      [domainLengths] = DomainLength(domainPoints);
        
      dim=1;
      [obj.nodeX,obj.faceX]=facesZVB(domainLengths(dim),...
          meshSizes(dim),domainPoints([1],[1]));
      
      dim=2;
      [obj.nodeY,obj.faceY]=facesZVB(domainLengths(dim),...
          meshSizes(dim),domainPoints([2],[1]));
      
            U   = zeros(numel(obj.nodeX),numel(obj.nodeY));
            V   = zeros(numel(obj.nodeX),numel(obj.nodeY));
            Uf  = zeros(numel(obj.faceX),numel(obj.faceY));
            Vf  = zeros(numel(obj.faceX),numel(obj.faceY));
            
            for indPX=1:numel(obj.nodeX)
                for indPY=1:numel(obj.nodeY)

                    obj.U(indPX,indPY) =  0;
                    obj.V(indPX,indPY) =  v0;
                                       
                end
            end
            
            for indPX=1:(numel(obj.faceX))
                for indPY=1:(numel(obj.faceY))
 
                    obj.Uf(indPX,indPY) =  0;
                    obj.Vf(indPX,indPY) =  v0;
                    
                end
            end    
    end  
    
    
    
    function [s]=surfX(obj)
      s=obj.faceX(2:end)-obj.faceX(1:end-1);
    end
    function [s]=surfY(obj)
      s=obj.faceY(2:end)-obj.faceY(1:end-1);
    end
  end
end

%Domain Length
function [domainLengths] = DomainLength (domainPoints)

xLength = domainPoints([1],[2])-domainPoints([1],[1]);  
yLength = domainPoints([2],[2])-domainPoints([2],[1]);                              
domainLengths=[xLength, yLength]; 

end

%facesZeroVolumeBoundaries
function [nx,fx]=facesZVB(length,numCV,initPoint)

fx=linspace(initPoint,initPoint+length,numCV+1);
nx(1,1)=initPoint;
nx(1,2:numCV+1)=(fx(2:end)+fx(1:end-1))*0.5;
nx(1,numCV+2)=initPoint+length;

end



