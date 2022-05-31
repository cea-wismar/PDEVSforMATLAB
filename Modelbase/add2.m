classdef add2 < handle
%% Description
%  adds two inputs
%% Ports
%  inputs: 
%    in1, in2 incoming values
%  outputs: 
%    out      sum of input values
%% States
%  s: idle|go
%  u1,u2: current input values
%% System Parameters
%  name:  object name
%  debug: flag to enable debug information

  properties
    s
    u1
    u2
    name
    debug
  end
    
  methods
    function obj = add2(name, debug)
      obj.s = "idle";
      obj.u1 = 0;
      obj.u2 = 0;
      obj.name = name;
      obj.debug = debug;
    end
        
    function dint(obj)
      if obj.debug
        fprintf("%-8s entering int, being in phase %s\n", ...
	              obj.name, obj.s)
        showState(obj);
      end
      switch obj.s
        case "go"
          obj.s = "idle";
        otherwise
          fprintf("wrong phase %s in %s\n", obj.s, obj.name);
      end
      if obj.debug
        fprintf("%-8s leaving int, going to phase %s\n", obj.name, obj.s)
        showState(obj);
      end
    end
    
    function dext(obj,e,x)
      if obj.debug
        fprintf("%-8s entering ext, being in phase %s\n", obj.name, obj.s)
        showState(obj);
      end
      
      if isfield(x, "in1")
        obj.u1 = x.in1;
      end
      if isfield(x, "in2")
        obj.u2 = x.in2;
      end
      obj.s = "go";

      if obj.debug
        fprintf("%-8s  leaving ext, going to phase %s\n", obj.name, obj.s)
        showState(obj);
      end
    end
    
    function dcon(obj,e,x)
      if obj.debug    
        fprintf("%-8s con, in phase %s\n", obj.name, obj.s)
      end
      dint(obj);
      dext(obj,e,x);
    end
    
    function y = lambda(obj)
      switch obj.s
        case "go"
          y.out = obj.u1 + obj.u2;
        otherwise
          fprintf("la: wrong phase %s in %s\n", obj.s, obj.name);
      end
      if obj.debug
        fprintf("%-8s OUT, out=%2d\n", obj.name, y.out)
      end
    end
        
    function t = ta(obj)
      switch obj.s
        case "idle"
          t = inf;
        case "go"
          t = 0;
        otherwise
          fprintf("wrong phase %s in %s\n", obj.s, obj.name);
      end
    end
    
    function showState(obj)
      % debug function, prints current state
      fprintf("  phase=%s u1=%3d u2=%3d\n", obj.s, obj.u1, obj.u2);
    end  

  end
end
