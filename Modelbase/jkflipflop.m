classdef jkflipflop < handle
%% Description
%  JK flipflop with negative triggering
%% Ports
%  inputs: 
%    j, k, clk
%  outputs: 
%    q, qb
%% States
%  s: idle|go
%  j, k, clk: store inputs
%  q: actual state of the flipflop
%% System Parameters
%  name:  object name
%  q0: initial state
%  debug: model debug level
  
  properties
    s
    j
    clk
    k
    q
    name
    q0
    debug
  end
  
  methods
    function obj = jkflipflop(name, q0, dbg)
      obj.s = "idle";
      obj.j = 0;
      obj.k = 0;
      obj.clk = 0;
      obj.q = q0;
      obj.name = name;
      obj.q0 = q0;
      obj.debug = dbg;
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
          fprintf('dInt: wrong phase %s in %s\n', obj.s, obj.name);
      end
      
      if obj.debug
        fprintf('%-8s  leaving int, going to phase %s\n', obj.name, obj.s)
        showState(obj);
      end
    end

    function dext(obj,e,x)
      if obj.debug
        fprintf("%-8s entering ext, being in phase %s\n", obj.name, obj.s)
        showState(obj);
      end
      
      [j, k, clk] = readInputBag(obj, x);
      switch obj.s
        case "idle"
          obj.j = j; 
          obj.k = k; 
          if clk == 0 && obj.clk == 1  % falling edge
            obj.s = "go";
            q = obj.q;      % for shortness
            obj.q = (j && ~k) || (q && ~k) || (j && k && ~q);
          end
          obj.clk = clk; 
        otherwise
          fprintf("wrong phase %s in %s\n", obj.s, obj.name);
      end

      if obj.debug
        fprintf("%-8s  leaving ext, going to phase %S\n", obj.name, obj.s)
        showState(obj);
      end
    end
 
    function dcon(obj,e,x)
      % first back to idle, then next input
      if obj.debug
        fprintf("%-8s con, in phase %s\n", obj.name, obj.s)
      end
      dint(obj);
      dext(obj,e,x);
    end
    
   function y = lambda(obj)
      switch obj.s
        case "go"
          y.q = obj.q;
          y.qb = 1 - obj.q;
        otherwise
          fprintf("la: wrong phase %s in %s\n", obj.s, obj.name);
      end
      if obj.debug
        fprintf("%-8s OUT, q=%1d\n", obj.name, y.q)
      end
    end

    function t = ta(obj)
      switch obj.s
        case "idle"
          t = inf;
        case "go"
          t = 0;
        otherwise
          fprintf("wrong phase %s in %s\n"', obj.s, obj.name);
      end
    end
        
    %-------------------------------------------------------
    function [j, k, clk] = readInputBag(obj, x)
      % returns vector of input values
      % uses state values for missing input
      if isfield(x, "j")
        j = x.j;
      else
        j = obj.j;
      end

      if isfield(x, "k")
        k = x.k;
      else
        k = obj.k;
      end
      
      if isfield(x, "clk")
        clk = x.clk;
      else
        clk = obj.clk;
      end
    end
    
    function showState(obj)
      % debug function, prints current state (without phase)
      fprintf("  j=%1d k=%1d clk=%1d q=%1d\n", ...
               obj.j, obj.k, obj.clk, obj.q);
    end

  end
end
