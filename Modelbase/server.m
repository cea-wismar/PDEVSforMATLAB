classdef server < handle
%% Description
%  processes one entity in time tS
%% Ports
%  inputs: 
%    in   incoming entities
%  outputs: 
%    out      outgoing entities
%    working  true/false
%    n        current number of entities in server
%% States
%  s:   idle|go|busy
%  E:   id of processed entity
%  sig: next switching time
%% System Parameters
%  name:  object name
%  tS:    service time
%  debug: model debug level
%
  properties
    s
    E
    sig
    name
    tS
    debug
  end
  
  methods
    function obj = server(name, tS, dbg)
      obj.s = "idle";
      obj.sig = inf;
      obj.name = name;
      obj.tS = tS;
      obj.debug = dbg;
     end
    
    function dint(obj)
      if obj.debug
        fprintf("%-8s entering int, being in phase %s\n", obj.name, obj.s)
        showState(obj);
      end
     switch obj.s
        case "go"
          obj.s = "busy";
          obj.sig = obj.tS;
        case "busy"
          obj.s = "idle";
          obj.E = [];
        otherwise
          fprintf("dInt: wrong phase %s in %s\n", obj.s, obj.name);
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
      switch obj.s
        case "idle"
          obj.s = "go";
          obj.E = x.in;
        case "busy"
          fprintf("dExt: in phase %s in %s - dropping input\n", obj.s, obj.name);
          obj.sig = obj.tS - e;
        otherwise
          fprintf("dExt: in phase %s in %s - dropping input\n", obj.s, obj.name);
      end  
      if obj.debug
        fprintf("%-8s leaving ext, going to phase %s\n", obj.name, obj.s)
        showState(obj);
      end
    end
    
    function dcon(obj,e,x)
      if obj.debug    
        fprintf("%-8s con, in phase %s\n", obj.name, obj.s)
      end
      switch obj.s
        case "go" % blocking came to late -> ignore input
          dint(obj);
        otherwise   % first current entity leaves, then new one enters
          dint(obj);
          dext(obj,e,x);
      end
    end
    
    function y=lambda(obj)
      if obj.debug; fprintf("%-8s OUT ", obj.name); end
      switch obj.s
        case "go"
          y.working = true;
          if obj.debug; fprintf("working=%2d", y.working); end
        case "busy"
          y.out = obj.E;
          y.working = false;
          if obj.debug; fprintf("working=%2d out=%2d", y.working, y.out); end
        otherwise
          fprintf("la: wrong phase %s in %s\n", obj.s, obj.name);
      end
      y.n = double(y.working);
      if obj.debug; fprintf("\n"); end
    end
    
    function t = ta(obj)
      switch obj.s
        case "idle"
          t = inf;
        case "go"
          t = 0;
        case "busy"
          t = obj.sig;
      end  
    end
    
    function showState(obj)
      % debug function, prints current state
      fprintf("  phase=%s E=%d sig=%4.2f\n", obj.s, obj.E, obj.sig)
    end
    
  end
end