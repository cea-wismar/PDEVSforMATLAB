classdef pipe < handle
    properties
        s
        name
        E
    end
    methods
        function obj = pipe(name)
            obj.name = name;
            obj.s = 'idle';
        end
        function dint(obj)
            if strcmp(obj.s,'stateA') || strcmp(obj.s,'stateB') 
                obj.s = 'wait';
            else
                obj.s = 'idle';
            end
        end
        function dext(obj,e,x)
            obj.E = x.in;
            obj.s = 'stateA';
        end
        function dcon(obj,e,x)
            obj.E = x.in;
            obj.s = 'stateB';
        end
        function y=lambda(obj)
            
            if strcmp(obj.s,'stateA')
                y.out_p = obj.E;
            elseif strcmp(obj.s,'wait')
                y.out_d = obj.E;
            elseif strcmp(obj.s,'stateB')
                y.out_p = obj.E;
            else
                y = [];
            end
        end
        function t = ta(obj)
            if(strcmp(obj.s,"idle"))
                t = Inf;
            elseif(strcmp(obj.s,"wait"))
                t = 1.00;
            else
                t = 0.00;
            end
        end
    end
   
end