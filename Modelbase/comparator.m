classdef comparator < handle
%% Description
%  returns 1 if in >= 0, else 0
%% Ports
%  inputs: 
%    in       incoming value
%  outputs: 
%    out      1 if in >= 0, else 0 
%% States
%  s:   output
%  s:   idle
%  value
%% System Parameters
%  name:  object name
%  debug: flag to enable debug information

  properties
    s
    value
    name
    debug
  end
    
  methods
    function obj = comparator(name, debug)
      obj.s = "idle";
      obj.name = name;
      obj.debug = debug;
    end
        
    function dint(obj)
	   if obj.debug
		  fprintf("%-8s entering int, being in phase %s\n", ...
			 obj.name, obj.s)
		  showState(obj);
	   end
	   
	   obj.s = "idle";
	   
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
	   
	   obj.value = x.in;
	   obj.s = "output";
	   
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
      
	   if obj.s == "output"
		  if obj.value >= 0.0
			 y.out = 1;
		  else
			 y.out = 0;
		  end
	   end
	   if obj.debug
		  fprintf("%-8s OUT, out=%2d\n", obj.name, y.out)
	   end
    end
        
    function t = ta(obj)
      switch obj.s
        case "idle"
          t = inf;
        case "output"
          t = 0;
        otherwise
          fprintf("wrong phase %s in %s\n", obj.s, obj.name);
      end
    end
    
    function showState(obj)
      % debug function, prints current state
      fprintf("  phase=%s value=%3d\n", obj.s, obj.value);
    end  

  end
end
