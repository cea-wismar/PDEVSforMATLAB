classdef terminator1 < handle
%% Description
%  terminates incoming entities
%  send number of terminated entities to global variable simout
%% Ports
%  inputs:
%    in       incoming entities
%  outputs: none
%% States
%  ni:  number of terminated entities
%  s:   running
%  t:   time of last input
%% System Parameters
%  name:     object name
%  varname:  name of output field 

  properties
    t
    ni
    s
    name
    varname
  end
  
  methods
    function obj = terminator1(name, varname, t0)
      obj.name = name;
      obj.varname = varname;
      obj.s = "running";
      obj.t = t0;
      obj.ni = 0;
    end
    
    function dext(obj,e,x)
      obj.ni = obj.ni + 1;  % no bag - one input at a time
      doOut(obj, e);
    end
    
    function t = ta(obj)
      t = Inf;
    end
    
    function doOut(obj, e)
      global simout
      fun = @(x) strcmp(x,obj.varname);
      obj.t = obj.t + e;
      if (isempty(simout))
        simout.(obj.varname).y=obj.ni;
        simout.(obj.varname).t=obj.t;
      elseif ( ~any(fun(fieldnames(simout))) )
        simout.(obj.varname).y=obj.ni;
        simout.(obj.varname).t=obj.t;
      else
        simout.(obj.varname).y=[simout.(obj.varname).y,obj.ni];
        simout.(obj.varname).t=[simout.(obj.varname).t,obj.t];
      end
    end
    
  end
end
