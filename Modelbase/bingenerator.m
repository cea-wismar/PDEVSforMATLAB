classdef bingenerator < handle
%% Description
%  generates binary output values at given times
%  changes output at each given time
%  repeats cyclically
%% Ports
%  inputs: none
%  outputs: 
%    out      next binary value
%% States
%  s          running
%  z          internal state
%  index      index of next time value
%% System Parameters
%  z0: initial state
%  tVec: vector of output times 
%  debug: flag to enable debug information

  properties
    z
    index
    name
    s
    z0
    tVec
    debug
  end
  
  methods
    function obj = bingenerator(name, z0, tVec, dbg)
      obj.z = z0;
      obj.index = 0;
      obj.name = name;
      obj.s = "running";
      obj.z0 = z0;
      obj.tVec = tVec;
      obj.debug = dbg;
    end
        
    function dint(obj)
      if obj.debug
        fprintf("%-8s entering int with z=%1d, index=%d\n", ...
	            obj.name, obj.z, obj.index)
      end
      
      obj.index = mod(obj.index, length(obj.tVec)) + 1;
      obj.z = ~obj.z;
      
      if obj.debug
        fprintf("%-8s  leaving int with z=%1d, index=%d\n", ...
		        obj.name, obj.z, obj.index)
      end
    end
               
    function dext(obj,e,x)
    end
    
    function dcon(obj,e,x)
    end
        
    function y=lambda(obj)
      y.out = obj.z;

      if obj.debug
        fprintf("%-8s OUT, out=%2d\n", obj.name, y.out);
      end
    end

    function t = ta(obj)
      if obj.index == 0
        t = 0;     % output initial value
      elseif obj.index == 1
        t = obj.tVec(1);
      else
        t = obj.tVec(obj.index) ...
               - obj.tVec(obj.index - 1);
      end
      if obj.debug
        fprintf("%-8s TA, ta=%2d\n", obj.name, t);
      end
    end
    
  end
end
