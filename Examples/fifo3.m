function [out] = fifo3(tend)

    global simout
    global epsilon
    global DEBUGLEVEL
    simout = [];
    DEBUGLEVEL = 0;           % simulator debug level
    epsilon = 1e-6;

    if(nargin ~= 1)
	   tend = 80;
    end
    
    nG = 40;
    tG = 1;
    tS = 4.5;
    debug = false;

    N1 = coordinator("N1");

    Generator = devs(generator1("Generator", tG, 1, nG, debug));
    Distribute3 = devs(distribute3("Distribute3", 1, debug));
    NQ1 = queueserverCM("NQ1", tS, debug);
    NQ2 = queueserverCM("NQ2", tS, debug);
    NQ3 = queueserverCM("NQ3", tS, debug);
    Combine3 = devs(combine3("Combine3", debug));
    Smallestin = devs(smallestin3("Smallestin", debug));
    Terminator = devs(terminator("Terminator"));
    QsNout1 = devs(toworkspace("QsNout1", "qsNOut1", 0));
    QsNout2 = devs(toworkspace("QsNout2", "qsNOut2", 0));
    QsNout3 = devs(toworkspace("QsNout3", "qsNOut3", 0));
    Combout = devs(toworkspace("Combout", "combOut", 0));

    towsgenout = devs(toworkspace("towsgenout", "towsgenout", 0));
    towsdistriout1 = devs(toworkspace("towsdistriout1", "towsdistriout1", 0));
    towsdistriout2 = devs(toworkspace("towsdistriout2", "towsdistriout2", 0));
    towsdistriout3 = devs(toworkspace("towsdistriout3", "towsdistriout3", 0));

    towssmallestint = devs(toworkspace("towssmallestint", "towssmallestint", 0));
    towscombineout = devs(toworkspace("towscombineout", "towscombineout", 0));

    towsNQ1out = devs(toworkspace("towsNQ1out", "towsNQ1out", 0));
    towsNQ1n = devs(toworkspace("towsNQ1n", "towsNQ1n", 0));
    towsNQ2out = devs(toworkspace("towsNQ2out", "towsNQ2out", 0));
    towsNQ2n = devs(toworkspace("towsNQ2n", "towsNQ2n", 0));
    towsNQ3out = devs(toworkspace("towsNQ3out", "towsNQ3out", 0));
    towsNQ3n = devs(toworkspace("towsNQ3n", "towsNQ3n", 0));


    N1.add_model(Generator);
    N1.add_model(Distribute3);
    N1.add_model(NQ1);
    N1.add_model(NQ2);
    N1.add_model(NQ3);
    N1.add_model(Combine3);
    N1.add_model(Smallestin);
    N1.add_model(Terminator);
    N1.add_model(QsNout1);
    N1.add_model(QsNout2);
    N1.add_model(QsNout3);
    N1.add_model(Combout);

    N1.add_model(towsgenout);
    N1.add_model(towsdistriout1);
    N1.add_model(towsdistriout2);
    N1.add_model(towsdistriout3);
    N1.add_model(towssmallestint);
    N1.add_model(towscombineout);
    N1.add_model(towsNQ1out);
    N1.add_model(towsNQ1n);
    N1.add_model(towsNQ2out);
    N1.add_model(towsNQ2n);
    N1.add_model(towsNQ3out);
    N1.add_model(towsNQ3n);

    N1.add_coupling("Generator","out","towsgenout","in");
    N1.add_coupling("Distribute3","out1","towsdistriout1","in");
    N1.add_coupling("Distribute3","out2","towsdistriout2","in");
    N1.add_coupling("Distribute3","out3","towsdistriout3","in");
    N1.add_coupling("Smallestin","out","towssmallestint","in");
    N1.add_coupling("Combine3","out","towscombineout","in");
    N1.add_coupling("NQ1","n","towsNQ1n","in");
    N1.add_coupling("NQ2","n","towsNQ2n","in");
    N1.add_coupling("NQ3","n","towsNQ3n","in");
    N1.add_coupling("NQ1","out","towsNQ1out","in");
    N1.add_coupling("NQ2","out","towsNQ2out","in");
    N1.add_coupling("NQ3","out","towsNQ3out","in");

    N1.add_coupling("Generator","out","Distribute3","in");
    N1.add_coupling("Distribute3","out1","NQ1","in");
    N1.add_coupling("Distribute3","out2","NQ2","in");
    N1.add_coupling("Distribute3","out3","NQ3","in");
    N1.add_coupling("NQ1","out","Combine3","in1");
    N1.add_coupling("NQ2","out","Combine3","in2");
    N1.add_coupling("NQ3","out","Combine3","in3");
    N1.add_coupling("Combine3","out","Terminator","in");
    N1.add_coupling("NQ1","n","Smallestin","in1");
    N1.add_coupling("NQ2","n","Smallestin","in2");
    N1.add_coupling("NQ3","n","Smallestin","in3");
    N1.add_coupling("Smallestin","out","Distribute3","port");
    N1.add_coupling("NQ1","n","QsNout1","in");
    N1.add_coupling("NQ2","n","QsNout2","in");
    N1.add_coupling("NQ3","n","QsNout3","in");
    N1.add_coupling("Combine3","out","Combout","in");

    root = rootcoordinator("root",0,tend,N1,0);
    root.sim();

    figure("Position",[1 1 450 450]);
    subplot(2,1,1)
    stem(simout.combOut.t,simout.combOut.y);
    xlim([0, tend])
    ylim([0, max(simout.combOut.y) + 5])
    ylabel("out");
    title("outgoing entities");

    subplot(2,1,2)
    stairs(simout.qsNOut1.t,simout.qsNOut1.y);
    hold('on')
    stairs(simout.qsNOut2.t,simout.qsNOut2.y);
    stairs(simout.qsNOut3.t,simout.qsNOut3.y);
    hold('off')
    xlim([0, tend])
    ylim([0, max(simout.qsNOut3.y) + 5])
    ylabel("n");
    title("queue+server loads");

    figure
    subplot(2,3,1)
    stem(simout.NQ1_towsqueueout.t,simout.NQ1_towsqueueout.y); title("NQ1 Queue out"); xlim([0 tend]);
    subplot(2,3,2)
    stem(simout.NQ2_towsqueueout.t,simout.NQ2_towsqueueout.y); title("NQ2 Queue out"); xlim([0 tend]);
    subplot(2,3,3)
    stem(simout.NQ3_towsqueueout.t,simout.NQ3_towsqueueout.y); title("NQ3 Queue out"); xlim([0 tend]);
    subplot(2,3,4)
    stem(simout.NQ1_towsqueuenq.t,simout.NQ1_towsqueuenq.y); title("NQ1 Queue nq"); xlim([0 tend]);
    subplot(2,3,5)
    stem(simout.NQ2_towsqueuenq.t,simout.NQ2_towsqueuenq.y); title("NQ2 Queue nq"); xlim([0 tend]);
    subplot(2,3,6)
    stem(simout.NQ3_towsqueuenq.t,simout.NQ3_towsqueuenq.y); title("NQ3 Queue nq"); xlim([0 tend]);

    figure
    subplot(3,3,1)
    stem(simout.NQ1_towsserverout.t,simout.NQ1_towsserverout.y); title("NQ1 Server out"); xlim([0 tend]);
    subplot(3,3,2)
    stem(simout.NQ2_towsserverout.t,simout.NQ2_towsserverout.y); title("NQ2 Server out"); xlim([0 tend]);
    subplot(3,3,3)
    stem(simout.NQ3_towsserverout.t,simout.NQ3_towsserverout.y); title("NQ3 Server out"); xlim([0 tend]);
    subplot(3,3,4)
    stem(simout.NQ1_towsserverworking.t,simout.NQ1_towsserverworking.y); title("NQ1 Server working"); xlim([0 tend]);
    subplot(3,3,5)
    stem(simout.NQ2_towsserverworking.t,simout.NQ2_towsserverworking.y); title("NQ2 Server working"); xlim([0 tend]);
    subplot(3,3,6)
    stem(simout.NQ3_towsserverworking.t,simout.NQ3_towsserverworking.y); title("NQ3 Server working"); xlim([0 tend]);
    subplot(3,3,7)
    stem(simout.NQ1_towsservern.t,simout.NQ1_towsservern.y); title("NQ1 Server n"); xlim([0 tend]);
    subplot(3,3,8)
    stem(simout.NQ2_towsservern.t,simout.NQ2_towsservern.y); title("NQ2 Server n"); xlim([0 tend]);
    subplot(3,3,9)
    stem(simout.NQ3_towsservern.t,simout.NQ3_towsservern.y); title("NQ3 Server n"); xlim([0 tend]);

    figure
    subplot(1,3,1)
    stem(simout.NQ1_towsaddout.t,simout.NQ1_towsaddout.y); title("NQ1 add out"); xlim([0 tend]);
    subplot(1,3,2)
    stem(simout.NQ2_towsaddout.t,simout.NQ2_towsaddout.y); title("NQ2 add out"); xlim([0 tend]);
    subplot(1,3,3)
    stem(simout.NQ3_towsaddout.t,simout.NQ3_towsaddout.y); title("NQ3 add out"); xlim([0 tend]);

    figure
    subplot(5,1,1)
    stem(simout.towsgenout.t,simout.towsgenout.y); title("Generator out"); xlim([0 tend]);
    subplot(5,1,2)
    stem(simout.towssmallestint.t,simout.towssmallestint.y); title("smallestint out"); xlim([0 tend]);
    subplot(5,1,3)
    stem(simout.towsdistriout1.t,simout.towsdistriout1.y); title("Distribute out1"); xlim([0 tend]);
    subplot(5,1,4)
    stem(simout.towsdistriout2.t,simout.towsdistriout2.y); title("Distribute out2"); xlim([0 tend]);
    subplot(5,1,5)
    stem(simout.towsdistriout3.t,simout.towsdistriout3.y); title("Distribute out3"); xlim([0 tend]);

    out = simout;
    
end




