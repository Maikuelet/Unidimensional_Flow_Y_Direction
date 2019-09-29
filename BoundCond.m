%BOUNDARY CONDITIONS for defined PROPERTY
%----------------------------------------
classdef BoundCond < handle
    properties (SetAccess = private)
        bottomProp, leftProp, rightProp, upperProp
    end
    
    methods
        function obj = BoundCond(initProp, leftProp, rightProp)
            obj.bottomProp= initProp;
            obj.leftProp  = leftProp;
            obj.rightProp = rightProp;
            obj.upperProp = initProp;
        end
    end
end
    