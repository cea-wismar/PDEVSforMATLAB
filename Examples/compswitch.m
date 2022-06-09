function [out] = compswitch(tend)

    global simout
    global epsilon
    global DEBUGLEVEL
    simout = [];
    DEBUGLEVEL = 0;
    epsilon = 1e-6;
    
    if(nargin ~= 1)
	   tend = 10;
    end
    
    tVec = [1, 3, 7, 8, 9];
    yVec = [2, -3, -2, 1, -1];

    N1 = coordinator('N1');

    Generator = devs(vectorgen('Vectorgen', tVec, yVec,1));
    Terminator1 = devs(terminator('Terminator1'));
    Terminator2 = devs(terminator('Terminator2'));
    Vectorgenout = devs(toworkspace('Vectorgenout','vectorgenout',0));
    Comparatorout = devs(toworkspace('Comparatorout','comparatorout',0));
    Comparator = devs(comparator('Comparator', 1));
    Outputswitch = devs(outputswitch('Outputswitch', 0, 1));
    Gain = devs(gain('Gain',1,1));
    Outputswitchout0 = devs(toworkspace('Outputswitchout0','outputswitchout0',0));
    Outputswitchout1 = devs(toworkspace('Outputswitchout1','outputswitchout1',0));

    N1.add_model(Generator);
    N1.add_model(Terminator1);
    N1.add_model(Terminator2);
    N1.add_model(Vectorgenout);
    N1.add_model(Comparatorout);
    N1.add_model(Comparator);
    N1.add_model(Outputswitch);
    N1.add_model(Outputswitchout0);
    N1.add_model(Outputswitchout1);
    N1.add_model(Gain);

    N1.add_coupling('Vectorgen','out','Comparator','in');
    N1.add_coupling('Comparator','out','Outputswitch','sw');
    N1.add_coupling('Vectorgen','out','Gain','in');
    N1.add_coupling('Gain','out','Outputswitch','in');

    N1.add_coupling('Outputswitch','out0','Terminator1','in');
    N1.add_coupling('Outputswitch','out1','Terminator2','in');
    N1.add_coupling('Outputswitch','out0','Outputswitchout0','in');
    N1.add_coupling('Outputswitch','out1','Outputswitchout1','in');

    N1.add_coupling('Vectorgen','out','Vectorgenout','in');
    N1.add_coupling('Comparator','out','Comparatorout','in');


    root = rootcoordinator('root',0,tend,N1,0);
    tic;
    root.sim();
    ta=toc

    figure(2)
    subplot(2,2,1);
    stem(simout.vectorgenout.t,simout.vectorgenout.y); grid on;
    xlim([0 tend+1]);
    xlabel('simulation time');
    title('vectorgenout');

    subplot(2,2,2);
    stem(simout.comparatorout.t,simout.comparatorout.y); grid on;
    xlim([0 tend+1]);
    xlabel('simulation time');
    title('comparatorout');

    subplot(2,2,3);
    stem(simout.outputswitchout0.t,simout.outputswitchout0.y); grid on;
    xlim([0 tend+1]);
    xlabel('simulation time');
    title('outputswitchout0');

    subplot(2,2,4);
    stem(simout.outputswitchout1.t,simout.outputswitchout1.y); grid on;
    xlim([0 tend+1]);
    xlabel('simulation time');
    title('outputswitchout1');
   
    out = simout;
    
end