classdef queue < handle
%% Description
%  standard FIFO queue
%% Ports
%  inputs: 
%    in   incoming entities
%    bl   blocking status of output
%  outputs: 
%    out  outgoing entities
%% States
%  s: 0|1|2|3 == 
%    emptyFree|emptyBlocked|queuingFree|queuingBlocked
%  q:  vector of queued entities
%  n:  queue length
%% System Parameters
%  name:  object name
%  debug: model debug level
%
  properties
    s
    q
    n
    name
    debug
  end
  
  methods
    function obj = queue(name, dbg)
      obj.s = "emptyFree";
      obj.q = [];
      obj.n = 0;
      obj.name = name;
      obj.debug = dbg;
    end
    
    function dint(obj)
      if obj.debug
        fprintf('%-8s entering int, being in phase %s\n', obj.name, obj.s)
        showState(obj);
      end

      switch obj.s
        case "queuingFree"
          if length(obj.q) == 1
            obj.s = "emptyFree";
          else
            obj.s = "queuingFree";
          end
          obj.q = obj.q(2:end);
        otherwise
          fprintf("wrong phase %s in %s\n", obj.s, obj.name);
      end
      obj.n = length(obj.q);

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
      [bl, in] = readInputBag(obj, x);
      
      switch obj.s
        case "emptyFree"
          if bl == true && isempty(in)
            obj.s = "emptyBlocked";
          elseif bl == true && ~isempty(in)
            obj.s = "queuingBlocked";
            obj.q = [obj.q, in];
          elseif ~isempty(in)
            obj.s = "queuingFree";
            obj.q = [obj.q, in];             
          else
            % no entities, bl status remains
          end
        case "emptyBlocked"
          if bl == false && isempty(in)
            obj.s = "emptyFree";
          elseif bl == false && ~isempty(in)
            obj.s = "queuingFree";
            obj.q = [obj.q, in];
          elseif ~isempty(in)
            obj.s = "queuingBlocked";
            obj.q = [obj.q, in];             
          else
            % no entities, bl status remains
          end
        case "queuingFree"
          if bl == true
            obj.s = "queuingBlocked";
            obj.q = [obj.q, in];
          else
            obj.q = [obj.q, in];             
          end
        case "queuingBlocked"
          if bl == false
            obj.s = "queuingFree";
            obj.q = [obj.q, in];
          else
            obj.s = "queuingBlocked";
            obj.q = [obj.q, in];             
          end
        otherwise
          fprintf('wrong phase %s in %s\n', obj.s, obj.name);
      end
      obj.n = length(obj.q);
      if obj.debug
        fprintf("%-8s  leaving ext, going to phase %s\n", ...
		       obj.name, obj.s)
        showState(obj);
      end
    end
    
    function dcon(obj,e,x)
      % first current entity leaves, then new one enters
      if obj.debug
        fprintf("%-8s con, in phase %s\n", obj.name, obj.s)
      end
      [bl, ~] = readInputBag(obj, x);
      if bl == true  % direkt nach queuingBlocked, KEINE entity raus!
        dext(obj,e,x);
      else
        dint(obj);
        dext(obj,e,x);
      end
    end
    
    function y=lambda(obj)
      switch obj.s
        case "queuingFree"
          y.out = obj.q(1);
        otherwise
          fprintf("la: wrong phase %s in %s\n", obj.s, obj.name);
      end

      if obj.debug
        fprintf("%-8s OUT, nq=%2d out=%2d\n", obj.name, obj.n, y.out)
      end      
    end
    
    function t = ta(obj)
      switch obj.s
        case "emptyFree"
          t = inf;
        case "emptyBlocked"
          t = inf;
        case "queuingFree"
          t = 0;
        case "queuingBlocked"
          t = inf;
        otherwise
          fprintf("wrong phase %s in %s\n", obj.s, obj.name);
      end
    end
    
    %-------------------------------------------------------
    function [bl, in] = readInputBag(obj, x)
      % returns last blocking input, -1, if there is none
      % returns vector of input entities
      if isfield(x, "bl")
        bl = x.bl(end);
      else
        bl = -1;
      end

      if isfield(x, "in")
        in = x.in;
      else
        in = [];
      end 
    end
    
    function showState(obj)
      % debug function, prints current state
      fprintf("  phase=%8s n=%1d queue=", obj.s, obj.n)
      fprintf("%2d ", obj.q)
      fprintf("\n")
    end
 
  end
end
