% PROPERTIES TO BE SAVED FOR THE POST PROCESSING AND SOLVING
%----------------------------------------------------------


classdef Properties < handle
    properties  (SetAccess = public)
        
        T, T0, Tt
        
    end 
    
    methods 
        function obj = Properties(mesh, initProp)
            
            obj.T = zeros(numel(mesh.nodeX),numel(mesh.nodeY))+initProp;
            obj.T0 = zeros(numel(mesh.nodeX),numel(mesh.nodeY))+initProp;
            obj.Tt = zeros(numel(mesh.nodeX),numel(mesh.nodeY))+initProp;            
        end
    end
end