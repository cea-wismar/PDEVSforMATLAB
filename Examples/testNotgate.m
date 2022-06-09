function [out] = testNotgate(tend)
    global simout
    global epsilon
    global DEBUGLEVEL
    simout = [];
    DEBUGLEVEL = 0;           % simulator debug level
    epsilon = 1e-6;

    if(nargin ~= 1)
	   tend = 14;
    end
    
    s0 = 1;
    tVec = [2, 4, 7.5, 8.5];
    tend = 14;
    mdebug = false;

    N1 = coordinator('N1');

    Bingenerator = devs(bingenerator("Bingenerator", s0, tVec, mdebug));
    Notgate = devs(notgate("Notgate", mdebug));
    Terminator = devs(terminator1("Terminator", "termOut", 0));
    Binout = devs(toworkspace("Binout", "binOut", 0));
    Notout = devs(toworkspace("Notout", "notOut", 0));

    N1.add_model(Bingenerator);
    N1.add_model(Notgate);
    N1.add_model(Terminator);
    N1.add_model(Binout);
    N1.add_model(Notout);

    N1.add_coupling("Bingenerator","out","Notgate","in");
    N1.add_coupling("Notgate","out","Terminator","in");
    N1.add_coupling("Bingenerator","out","Binout","in");
    N1.add_coupling("Notgate","out","Notout","in");

    root = rootcoordinator("root",0,tend,N1,0);
    root.sim();

    figure
    subplot(2,1,1)
    stairs(simout.binOut.t,simout.binOut.y);
    hold("on");plot(simout.binOut.t,simout.binOut.y, "*");hold("off");
    grid("on");
    xlabel("simulation time");
    ylabel("out");
    title("Bingenerator");
    xlim([0, tend])
    ylim([-0.1, max(simout.binOut.y) + 0.1])

    subplot(2,1,2)
    stairs(simout.notOut.t,simout.notOut.y);
    hold("on");plot(simout.notOut.t,simout.notOut.y, "*");hold("off");
    grid("on");
    xlabel("simulation time");
    ylabel("out");
    title("Not");
    xlim([0, tend])
    ylim([-0.1, 1.1])

    out = simout;
end
