classdef notgate < handle
%% Description
%  logical NOT block
%% Ports
%  inputs: 
%    in
%  outputs: 
%    out
%% States
%  s: 0|1 == idle|go
%  z: internal state
%% System Parameters
%  name:  object name
%  debug: flag to enable debug information
  
  properties
    s
    z
    name
    debug
  end
  
  methods
    function obj = notgate(name, debug)
      obj.s = "idle";
      obj.z = [];
      obj.name = name;
      obj.debug = debug;
    end
        
    function dint(obj)
      if obj.debug
        fprintf("%-8s entering int, being in phase %s\n", obj.name, obj.s)
        showState(obj);
      end
      
      switch obj.s
        case "go"
          obj.s = "idle";
        otherwise
          fprintf("wrong phase %s in %s\n", obj.s, obj.name);
      end
      
      if obj.debug
        fprintf("%-8s  leaving int, going to phase %s\n", obj.name, obj.s)
        showState(obj);
      end
    end
    
    function dext(obj,e, x)
      if obj.debug
        fprintf("%8s entering ext, being in phase %s\n", obj.name, obj.s)
        showState(obj);
      end
 
      switch obj.s
        case "idle"
          if ~isempty(x.in)
            obj.z = ~x.in;
            obj.s = "go";
          end
        otherwise
          fprintf("wrong phase %s in %s\n", obj.s, obj.name);
      end

      if obj.debug
        fprintf("%-8s  leaving ext, going to phase %s\n", obj.name, obj.s)
        showState(obj);
      end
     end
     
    function dcon(obj,e,x)
      % first back to idle, then next input
      if obj.debug
        fprintf("%-8s con, in phase %s\n", obj.name, obj.s)
      end
      deltaintfun(obj);
      deltaextfun(obj,e,x);
    end
    
    function y = lambda(obj)
      switch obj.s
        case "go"
          y.out = obj.z;
        otherwise
          fprintf("la: wrong phase %s in %s\n", obj.s, obj.name);
      end
      if obj.debug
        fprintf("%-8s OUT, q=%1d\n", obj.name, y.out)
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
        
    %-------------------------------------------------------

    function showState(obj)
      % debug function, prints current state (without phase)
      fprintf("  z=%1d\n", obj.z);
    end

  end
end
