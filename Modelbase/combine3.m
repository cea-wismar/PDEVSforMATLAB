classdef combine3 < handle
%% Description
%  combines entities from three inputs into one output
%% Ports
%  inputs: 
%    in1, in2, in3   incoming entities
%  outputs: 
%    out      outgoing entities
%% States
%  s: idle|go
%  queue: vector of arrived entities
%% System Parameters
%  name:  object name
%  debug: flag to enable debug information
    
  properties
    s
    queue
    name
    debug
  end
  
  methods
    function obj = combine3(name, debug)
      obj.s ="idle"; 
      obj.queue = [];
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
          if length(obj.queue) == 1
            obj.s = "idle";
          else
            obj.s = "go";
          end
          obj.queue = obj.queue(2:end);
        otherwise
          fprintf("wrong phase %s in %s\n", obj.s, obj.name);
      end
      if obj.debug
        fprintf("%-8s  leaving int, going to phase %s\n", obj.name, obj.s)		                                                      
        showState(obj);
      end
    end
    
    function dext(obj,e,x)
      if obj.debug
        fprintf("%-8s entering ext, being in phase %s\n", obj.name, obj.s)
        showState(obj);
      end
      in = [];
      if isfield(x, "in1")
        in = [in, x.in1];
      end
      if isfield(x, "in2")
        in = [in, x.in2];
      end
      if isfield(x, "in3")
        in = [in, x.in3];
      end
      
      obj.s = "go";
      obj.queue = [obj.queue, in];             

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
          y.out = obj.queue(1);
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
      fprintf("  phase=%s queue=%2d\n", obj.s, obj.queue)
    end  

  end
end
