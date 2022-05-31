classdef generator < handle
    properties
        s
        name
        ts
        id
    end
    methods
        function obj = generator(name,ts)
            obj.name = name;
            obj.s = "prod";
            obj.ts = ts;
            obj.id = 0;
        end
        function dint(obj)
            obj.s = "prod";  
            obj.id = obj.id + 1;
        end
        function dext(obj,e,x)
        end
        function dcon(obj,e,x)
            obj.dint();
        end
        function y=lambda(obj)
            y.out = obj.id;
        end
        function t = ta(obj)
           t = obj.ts;
        end
    end
   
end