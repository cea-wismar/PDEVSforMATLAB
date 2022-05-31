classdef rootcoordinator
    
    properties
        name
        tstart
        tend
        mdl
        stepwise
        debug_level = get_debug_level();
    end
    
    methods
        function obj = rootcoordinator(name,tstart,tend,mdl,stepwise)
           obj.name = name;
           obj.tstart = tstart;
           obj.tend = tend;
           obj.mdl = mdl;
           obj.stepwise = stepwise;
           mdl.set_parent(obj);
        end
        function sim(obj)
            t=obj.tstart;
            if obj.debug_level == 1
                sequencestart('PDEVS');
                sequenceaddlink('start','root');
            end
            obj.mdl.imessage(t);
            if obj.debug_level == 1
                sequenceaddlink('done','root');
            end
            t=obj.mdl.get_tn()

            while (t <= obj.tend)
                obj.mdl.smessage(t);
                if obj.debug_level == 1
                    sequenceaddlink('done','root');
                end
                disp('-------------------------------------------------------------------------------');
                t=obj.mdl.get_tn()
                
                if(obj.stepwise)
                    pause();
                end
            end
            if obj.debug_level == 1
                SD = getappdata(gcf,'SD');
                nodes={};
                for k=1:length(SD.nodes)
                    nodes={nodes{:},SD.nodes(k).name};
                end
                
                xticks(1:length(SD.nodes));
                xticklabels(nodes);
                xtickangle(90);
            end
        end
        function ymessage(obj,y,name,t)
            if obj.debug_level == 1
                if isempty(y)
                    sequenceaddlink(sprintf('y-msg([],%s,%f)',name,t),obj.name);
                else
                    sequenceaddlink(sprintf('y-msg(y,%s,%f)',name,t),obj.name);
                end
            end
        end
    end
    
end

