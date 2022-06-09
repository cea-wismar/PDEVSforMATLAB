function [out] = testComparator(tend)

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
    Terminator = devs(terminator('Terminator'));
    Vectorgenout = devs(toworkspace('Vectorgenout','vectorgenout',0));
    Comparatorout = devs(toworkspace('Comparatorout','comparatorout',0));
    Comparator = devs(comparator('Comparator', 1));

    N1.add_model(Generator);
    N1.add_model(Terminator);
    N1.add_model(Vectorgenout);
    N1.add_model(Comparatorout);
    N1.add_model(Comparator);

    N1.add_coupling('Vectorgen','out','Comparator','in');
    N1.add_coupling('Comparator','out','Terminator','in');


    N1.add_coupling('Vectorgen','out','Vectorgenout','in');
    N1.add_coupling('Comparator','out','Comparatorout','in');

    root = rootcoordinator('root',0,tend,N1,0);
    tic;
    root.sim();
    ta=toc

    figure(2)
    subplot(2,1,1);
    stem(simout.vectorgenout.t,simout.vectorgenout.y); grid on;
    xlim([0 tend+1]);
    xlabel('simulation time');
    title('vectorgenout');

    subplot(2,1,2);
    stem(simout.comparatorout.t,simout.comparatorout.y); grid on;
    xlim([0 tend+1]);
    xlabel('simulation time');
    title('comparatorout');
    
    out = simout;

end
