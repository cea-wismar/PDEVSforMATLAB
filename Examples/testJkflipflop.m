function [out] = testJkflipflop(tend)
    global simout
    global epsilon
    global DEBUGLEVEL
    simout = [];
    DEBUGLEVEL = 0;           % simulator debug level
    epsilon = 1e-6;

    if(nargin ~= 1)
	   tend = 14;
    end
    
    tVec1 = [3, 4, 5, 6, 9, 11];        % J
    tVec2 = [0.5, 1.0];                 % CLK
    tVec3 = [1, 2, 7, 8, 10, 12, 100];  % K
    mdebug = false;

    N1 = coordinator('N1');

    Bingenerator1 = devs(bingenerator("Bingenerator1", 0, tVec1, mdebug));
    Bingenerator2 = devs(bingenerator("Bingenerator2", 1, tVec2, mdebug));
    Bingenerator3 = devs(bingenerator("Bingenerator3", 0, tVec3, mdebug));
    Jkff = devs(jkflipflop("JKFF", 0, mdebug));
    Terminator1 = devs(terminator("Terminator1"));
    Terminator2 = devs(terminator("Terminator2"));
    Binout1 = devs(toworkspace("Binout1", "binOut1", 0));
    Binout2 = devs(toworkspace("Binout2", "binOut2", 0));
    Binout3 = devs(toworkspace("Binout3", "binOut3", 0));
    Jkffout1 = devs(toworkspace("JKFFq", "qOut", 0));
    Jkffout2 = devs(toworkspace("JKFFqb", "qbOut", 0));

    N1.add_model(Bingenerator1);
    N1.add_model(Bingenerator2);
    N1.add_model(Bingenerator3);
    N1.add_model(Jkff);
    N1.add_model(Terminator1);
    N1.add_model(Terminator2);
    N1.add_model(Binout1);
    N1.add_model(Binout2);
    N1.add_model(Binout3);
    N1.add_model(Jkffout1);
    N1.add_model(Jkffout2);

    N1.add_coupling("Bingenerator1","out","JKFF","j");
    N1.add_coupling("Bingenerator2","out","JKFF","clk");
    N1.add_coupling("Bingenerator3","out","JKFF","k");
    N1.add_coupling("JKFF","q","Terminator1","in");
    N1.add_coupling("JKFF","qb","Terminator2","in");
    N1.add_coupling("Bingenerator1","out","Binout1","in");
    N1.add_coupling("Bingenerator2","out","Binout2","in");
    N1.add_coupling("Bingenerator3","out","Binout3","in");
    N1.add_coupling("JKFF","q","JKFFq","in");
    N1.add_coupling("JKFF","qb","JKFFqb","in");

    root = rootcoordinator("root",0,tend,N1,0);
    root.sim();

    figure
    subplot(5,1,1)
    stairs(simout.binOut1.t,simout.binOut1.y);
    title("J");
    xlim([0, tend])
    ylim([-0.1, 1.1])

    subplot(5,1,2)
    stairs(simout.binOut3.t,simout.binOut3.y);
    title("K");
    xlim([0, tend])
    ylim([-0.1, 1.1])

    subplot(5,1,3)
    stairs(simout.binOut2.t,simout.binOut2.y);
    title("CLK");
    xlim([0, tend])
    ylim([-0.1, 1.1])

    subplot(5,1,4)
    stairs(simout.qOut.t,simout.qOut.y);
    title("Q");
    xlim([0, tend])
    ylim([-0.1, 1.1])

    subplot(5,1,5)
    stairs(simout.qbOut.t,simout.qbOut.y);
    title("Qb");
    xlim([0, tend])
    ylim([-0.1, 1.1])
    
    out = simout;
end
