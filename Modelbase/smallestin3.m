classdef smallestin3 < handle
%% Description
%  outputs index of smallest input value among 3 inputs
%% Ports
%  inputs: 
%    in1, in2, in3   incoming values
%  outputs: 
%    out      index of smallest input
%% States
%  s: idle|go
%  n1,n2,n3: arrived values
%% System Parameters
%  name:  object name
%  debug: flag to enable debug information
    
  properties
    s
    n1
    n2
    n3
    name
    debug
  end
  
  methods
    function obj = smallestin3(name, debug)
      obj.s = "idle";
      obj.n1 = 0;
      obj.n2 = 0;
      obj.n3 = 0;
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
        obj.n1 = x.in1;
      end
      if isfield(x, "in2")
        obj.n2 = x.in2;
      end
      if isfield(x, "in3")
        obj.n3 = x.in3;
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
          [~, y.out] = min([obj.n1, obj.n2, obj.n3]);
        otherwise
          fprintf('la: wrong phase %d in %s\n', obj.s.phase, obj.name);
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
      fprintf("  phase=%s n1/2/3=%3d/%2d/%2d\n", obj.s, obj.n1, obj.n2, obj.n3);
    end  

  end
end
