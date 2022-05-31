classdef distribute3 < handle
%% Description
%  routes entities to one of three outputs according to port input
%% Ports
%  inputs: 
%    in        incoming entities
%    port      next output port
%  outputs: 
%    out1/2/3  outgoing entities
%% States
%  s:        idle|go
%  val:      arrived value
%  nextPort: output port of new in values
%% System Parameters
%  name:  object name
%  port0: initial port
%  debug: flag to enable debug information
    
  properties
    s
    val
    nextPort
    name
    port0
    debug
  end
  
  methods
    function obj = distribute3(name, port0, debug)
      obj.s = "idle";
      obj.val = [];
      obj.nextPort = port0;
      obj.name = name;
      obj.port0 = port0;
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
          obj.val = [];
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
      
      [port, in] = readInputBag(obj, x);
      if length(port) >= 1
        obj.nextPort = port;
      end
      if length(in) >= 1
        obj.val = in;             
        obj.s = "go";
      else
        obj.s = "idle";
        obj.val = [];             
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
      switch obj.s
        case "go"
          switch obj.nextPort
            case 1
              y.out1 = obj.val;
            case 2
              y.out2 = obj.val;
            case 3
              y.out3 = obj.val;
            otherwise
             fprintf("la: wrong port %d in %s\n", obj.nextPort, obj.name);
          end
        otherwise
          fprintf("la: wrong phase %s in %s\n", obj.s, obj.name);
      end
      if obj.debug
       fprintf("%-8s OUT, out=%2d at port=%2d\n", ...
               obj.name, obj.val, obj.nextPort);
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
        
    function [port, in] = readInputBag(obj, x)
      % returns new port (or NaN) and latest entity (or [])
      if isfield(x, "in")
        in = x.in;
      else
        in = [];
      end
      if isfield(x, "port")
        port = x.port;
      else
        port = [];
      end
    end
    
    function showState(obj)
      % debug function, prints current state
      fprintf("  phase=%s val=%4.2f nextPort=%2d\n", obj.s, ...
              obj.val, obj.nextPort);
    end  

  end
end
