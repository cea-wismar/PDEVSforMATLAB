classdef queue_dj < handle
    properties
        s
        name
        q
        n
        bl
    end
    methods
        function obj = queue_dj(name,debug)
            obj.name = name;
            obj.s = 'idle';
            obj.q = [];
            obj.n = 0;
            obj.bl = 0;
        end
        function dint(obj)
            if strcmp(obj.s,'Nout')
                if obj.bl == 1 || obj.n == 0
                    obj.s = 'idle';
                else
                    obj.s = 'Eout';
                end
            elseif strcmp(obj.s,'Eout')
                obj.s = 'Nout';
                obj.n = obj.n - 1;
                obj.q = obj.q(2:end);
            else
                %kann nicht erreicht werden
                disp('error in modell queue_dj');
                pause;
            end
        end
        function dext(obj,e,x)
            if isfield(x,'in') && ~isempty(x.in)
                obj.q = [obj.q, x.in];
                obj.n = obj.n + 1;
                if isfield(x,'bl') && ~isempty(x.bl)
                   obj.bl = x.bl; 
                end
                obj.s = 'Nout';
            elseif isfield(x,'bl') && ~isempty(x.bl)
                obj.bl = x.bl;
                if obj.bl == 0 && obj.n > 0
                    obj.s = 'Eout';
                else
                    obj.s = 'idle';
                end
            else
                %kann nicht erreicht werden
                disp('error in modell queue_dj');
                pause;
            end
        end
        function dcon(obj,e,x)
            if strcmp(obj.s,'Nout')
                if isfield(x,'in') && ~isempty(x.in)
                    obj.q= [obj.q, x.in];
                    obj.n = obj.n + 1;
                    if isfield(x,'bl') && ~isempty(x.bl)
                        obj.bl = x.bl;
                    end
                elseif isfield(x,'bl') && ~isempty(x.bl)
                    obj.bl = x.bl;  
                else
                    %kann nicht erreicht werden
                    disp('error in modell queue_dj');
                    pause;
                end
            elseif strcmp(obj.s,'Eout')
                if isfield(x,'in') && ~isempty(x.in)
                    if isfield(x,'bl') && ~isempty(x.bl)
                        obj.bl = x.bl;
                        if obj.bl == 1
                            obj.n = obj.n + 1;
                            obj.q = [obj.q(1:end), x.in];
                        else
                            if obj.n > 1
                                obj.n = obj.n + 1;
                                obj.q = [obj.q(2:end), x.in];
                            else
                                obj.q = [x.in];
                                obj.n = 1;
                            end
                        end     
                    else
                        if obj.n > 1
                            obj.q = [obj.q(2:end),x.in];
                        else
                            obj.q = [x.in];
                            obj.n = 1;
                        end
                    end
                    obj.s = 'Nout';
                elseif isfield(x,'bl') && ~isempty(x.bl)
                    obj.bl = x.bl;
                    if obj.bl == 1
                        obj.s = 'idle';
                    else
                        obj.s = 'Eout';
                    end
                else
                    %kann nicht erreicht werden
                    disp('error in modell queue_dj');
                    pause;
                end
            else
                %kann nicht erreicht werden
                disp('error in modell queue_dj');
                pause;
            end
        end
        function y=lambda(obj)
            y = [];
            if strcmp(obj.s,'Eout')
                y.out = obj.q(1);
            elseif strcmp(obj.s,'Nout')
                y.nq = obj.n;
            end
        end
        function t = ta(obj)
            if(strcmp(obj.s,"idle"))
                t = Inf;
            elseif(strcmp(obj.s,"Nout") || strcmp(obj.s,'Eout'))
                t = 0.00;
            else
                %kann nicht erreicht werden
                disp('error in modell queue_dj');
                pause;
            end
        end
    end
   
end