classdef devs < handle
    properties
        parent  %parent coordinator
        tl      %time of last event
        tn      %time of next event
        DEVS    %model
        y       %output message bag
        e
        debug_level = get_debug_level();
        epsilon = get_epsilon;
    end
    
    methods
%% constructor        
        function obj = devs(mdl)
            obj.DEVS = mdl;
            obj.e = 0;
        end
%% set methods
        function set_parent(obj,value)
            obj.parent = value;
        end
        
        function set_model(obj,value)
            obj.DEVS = value;
        end
%% get methods       
        function tn = get_tn(obj)
            tn = obj.tn;
        end
        
        function tl = get_tl(obj)
            tl = obj.tl;
        end
        
        function name = get_name(obj)
            name = obj.DEVS.name;
        end
        
        function state = get_state(obj)
            state = obj.DEVS.s;
        end
%% copy methods
        function DEVS=copy(obj,name)
            args=cell(nargin(class(obj.DEVS)),1);
            mdl = feval(class(obj.DEVS),args{:});
            
            prop = properties(obj.DEVS);
            nprop = numel(prop);
            
            for k=1:nprop
                if strcmp(prop{k},'name')
                    mdl.(prop{k}) = name;
                else
                    mdl.(prop{k}) = obj.DEVS.(prop{k});
                end
            end
            
            DEVS = devs(mdl);
            
        end
 %% message functions       
        function imessage(obj,t)
            obj.tl = t - obj.e;
            obj.tn = obj.tl + obj.DEVS.ta();
            if obj.debug_level == 1
                sequenceaddlink(sprintf('i-msg(t=%f)',t),obj.get_name);
                sequenceaddlink(sprintf('%f = tl + ta(s)',obj.tn),obj.get_name);
            end
        end       
        function smessage(obj,t)
            if obj.debug_level == 1
                disp(['simulator: ' obj.DEVS.name ' s-message']);
                sequenceaddlink(sprintf('*-msg(t=%f)',t),obj.get_name);
            end
            if abs(t - obj.tn) <= obj.epsilon
                if obj.debug_level == 1
                    disp('call lambda');
                    sequenceaddlink('\lambda (s)',obj.get_name);
                end
                obj.y = obj.DEVS.lambda();
                obj.parent.ymessage(obj.y,obj.get_name,t);
            end
            
        end 
        function xmessage(obj,x,t)
            if obj.debug_level == 1
                disp(['simulator: ' obj.DEVS.name ' x-message ' 'value:']);
                disp(x);
                disp('old state: ');
                disp(obj.DEVS.s);
                if isempty(x)
                    sequenceaddlink(sprintf('x-msg([],t=%f)',t),obj.get_name);
                else
                    sequenceaddlink(sprintf('x-msg(x,t=%f)',t),obj.get_name);
                end
            end
            
            if isempty(x) && (abs(t - obj.tn) <= obj.epsilon)
               %internal transition 
               if obj.debug_level == 1
                    disp('call dint');
                    sequenceaddlink('\delta_{int} (s)',obj.get_name);
               end
               obj.DEVS.dint();
            elseif ~isempty(x) && (abs(t - obj.tn) <= obj.epsilon)
                %confluent transition
                if obj.debug_level == 1
                    disp('call dcon');
                    sequenceaddlink('\delta_{con} (s)',obj.get_name);
                end
                obj.e = t - obj.tl;
                obj.DEVS.dcon(obj.e,x);
            elseif ~isempty(x) && (obj.tl <= t && t <= obj.tn)
                %external transition
                if obj.debug_level == 1
                    disp('call dext');
                    sequenceaddlink('\delta_{ext} (s)',obj.get_name);
                end
                obj.e = t - obj.tl;
                obj.DEVS.dext(obj.e,x);
            end
            if obj.debug_level == 1
                disp('new state: ');
                disp(obj.DEVS.s);
                disp('call ta()');
            end
            obj.tl = t;
            obj.tn = t + obj.DEVS.ta();
            if obj.debug_level == 1
                disp(['tnext: ' num2str(obj.tn)]);
                sequenceaddlink(sprintf('%f = tl + ta(s)',obj.tn),obj.get_name);
            end
        end 
        
    end
end