classdef pipeout < handle
%% Description
%  routes input directly to output
%  copies its values to global variable simout
%% Ports
%  inputs: 
%    in   incoming entities
%  outputs: 
%    out      outgoing entities
%% States
%  s:   idle|forward
%  E:   last incoming value
%  t:   time of last input
%% System Parameters
%  name:     object name
%  varname:  name of output field
%
  properties
    s
    E
    t
    name
    varname
  end
  
  methods
    function obj = pipeout(name, varname, t0)
      obj.name = name;
      obj.varname = varname;
      obj.s = "idle";
      obj.t = t0;
    end
    
    function dint(obj)
      switch obj.s
        case "forward"
          obj.s = "idle";
        otherwise
          fprintf("dint: wrong phase %s in %s\n", obj.s, obj.name);
      end
    end
    
    function dext(obj,e,x)
      switch obj.s
        case "idle"
          obj.E = x.in;
          obj.s = "forward";
          doOut(obj, e, x);
        otherwise
          fprintf("dext: wrong phase %s in %s\n", obj.s, obj.name);
      end
    end
    
    function dcon(obj, e, x)
      switch obj.s
        case "forward"
          obj.E = x.in;
          obj.s = "forward";
          doOut(obj, e, x);
        otherwise
          fprintf("dcon: wrong phase %s in %s\n", obj.s, obj.name);
      end
    end
    
    function y=lambda(obj)
       switch obj.s
        case "forward"
          y.out = obj.E;
       end
    end
    
    function t = ta(obj)
      switch obj.s
        case "idle"
          t = Inf;
        case "forward"
          t = 0;
      end
    end
    
    function doOut(obj, e, x)
      global simout
      fun = @(x) strcmp(x,obj.varname);
      obj.t = obj.t + e;
      if (isempty(simout))
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
    
  end
end
