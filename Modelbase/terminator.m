classdef terminator < handle
    properties
        s
        name
        E
    end
    methods
        function obj = terminator(name)
            obj.name = name;
            obj.s = "idle";
        end
        function dint(obj)
            obj.s = "idle";  
        end
        function dext(obj,e,x)
            obj.E = x.in;
        end
        function dcon(obj,e,x)
            obj.dint();
            obj.dext(0,x);
        end
        function y=lambda(obj)
            
        end
        function t = ta(obj)
            t = Inf; 
        end
    end
   
end