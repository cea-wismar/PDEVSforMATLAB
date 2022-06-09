classdef outputswitch < handle
%% Description
%  routes input to one of two outputs according to sw input
%% Ports
%  inputs: 
%    in        incoming value
%    sw        output selector
%  outputs: 
%    out0/1    outgoing entities
%% States
%  s:        idle
%  s:        output
%  value
%  nextPort: output port of new in values
%% System Parameters
%  name:  object name
%  port0: initial port
%  debug: flag to enable debug information

  properties
    s
    nextPort
    value
    name
    port0
    debug
  end
    
  methods
    function obj = outputswitch(name, port0, debug)
      obj.s = "idle";
	 obj.nextPort = port0;
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
        if isfield(x, "in")
		  fprintf("in: %d\n",x.in);
	   end
	   if isfield(x, "sw")
		  fprintf("sw: %d\n",x.sw);
	   end
      end
      
      if isfield(x, "in")
        obj.value = x.in;
	   obj.s = "output";
      end
      if isfield(x, "sw")
        obj.port0 = x.sw;
      end
    

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
      
	 if obj.port0 == 0
		y.out0 = obj.value;
	 else
		y.out1 = obj.value;
	 end
      if obj.debug
		if obj.port0 == 0
			fprintf("%-8s OUT, out0=%2d\n", obj.name, y.out0)
		else
		    fprintf("%-8s OUT, out1=%2d\n", obj.name, y.out1)
		end
      end
    end
        
    function t = ta(obj)
      if obj.s == "output"
		t = 0;
	 else
		t = inf;
	 end
    end
    
    function showState(obj)
      % debug function, prints current state
      fprintf("  phase=%s nextPort=%3d value=%3d\n", obj.s, obj.nextPort, obj.value);
    end  

  end
end
