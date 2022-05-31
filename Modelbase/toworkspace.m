classdef toworkspace < handle
    properties
        s
        name
        varname
        t
    end
    methods
        function obj = toworkspace(name,varname,t0)
            obj.name = name;
            obj.s = "prod";
            obj.varname = varname;
            obj.t = t0;
        end
        function dint(obj)
            obj.s = "prod";  
        end
        function dext(obj,e,x)
            global simout
            fun = @(x) strcmp(x,obj.varname);
            obj.t = obj.t + e;
            if(isempty(simout))
                simout.(obj.varname).y=x.in;
                simout.(obj.varname).t=obj.t;
            elseif ( ~any(fun(fieldnames(simout))) )
                simout.(obj.varname).y=x.in;
                simout.(obj.varname).t=obj.t;
            else
                simout.(obj.varname).y=[simout.(obj.varname).y,x.in];
                simout.(obj.varname).t=[simout.(obj.varname).t,obj.t];
            end
        end
        function dcon(obj,e,x)
            obj.dext(0,x);
        end
        function y=lambda(obj)
            y=[];
        end
        function t = ta(obj)
           t = Inf;
        end
    end
   
end