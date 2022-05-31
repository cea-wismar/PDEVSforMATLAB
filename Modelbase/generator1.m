classdef generator1 < handle
%% Description
%  generates entities with fixed interarrival times
%% Ports
%  inputs: none
%  outputs: 
%    out      generated entities
%% States
%  s:  prod  (fix)  
%  id: number of workpieces generated
%% System Parameters
%  name:  object name
%  tG: time interval between new entities
%  n0: id of first entity
%  nG: total number of entities created
%  debug: flag to enable debug information
%
  properties
    s
    id
    name
    tG
    n0
    nG
    debug
  end
  
  methods
    function obj = generator1(name, tG, n0, nG, dbg)
      obj.name = name;
      obj.tG = tG;
      obj.n0 = n0;
      obj.nG = nG;
      obj.debug = dbg;
      obj.s = "prod";
      obj.id = n0;
    end
    
    function dint(obj)
      obj.s = "prod";  
      obj.id = obj.id + 1;
    end
    
    function dext(obj,e,x)
    end
    
    function dcon(obj,e,x)
    end
    
    function y=lambda(obj)
      y.out = obj.id;
      if obj.debug
        fprintf("%-8s OUT, out=%2d\n", obj.name, y.out)
      end
    end
    
    function t = ta(obj)
      if obj.id - obj.n0 < obj.nG 
        t = obj.tG;
      else
        t = inf;
      end
    end
    
  end   
end