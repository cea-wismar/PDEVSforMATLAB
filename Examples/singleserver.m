function [out] = singleserver(tend)
    global simout
    global epsilon
    global DEBUGLEVEL
    simout = [];
    DEBUGLEVEL = 0;           % simulator debug level
    epsilon = 1e-6;

    if(nargin ~= 1)
	   tend = 15;
    end
    
    nG = 100;
    tG = 1;
    tS = 1.5;
    mdebug = true;

    N1 = coordinator('N1');

    Generator = devs(generator1("Generator", tG, 1, nG, mdebug));
    Queue = devs(queue("Queue", mdebug));
    Server = devs(server("Server", tS, mdebug));
    Terminator = devs(terminator("Terminator"));
    GenOut = devs(toworkspace("GenOut", "genOut", 0));
    QueOut = devs(toworkspace("QueOut", "queOut", 0));
    SrvOut = devs(toworkspace("SrvOut", "srvOut", 0));

    N1.add_model(Generator);
    N1.add_model(GenOut);
    N1.add_model(Queue);
    N1.add_model(QueOut);
    N1.add_model(Server);
    N1.add_model(SrvOut);
    N1.add_model(Terminator);

    N1.add_coupling("Generator","out","Queue","in");
    N1.add_coupling("Queue","out","Server","in");
    N1.add_coupling("Server","out","Terminator","in");
    N1.add_coupling("Server","working","Queue","bl");
    N1.add_coupling("Generator","out","GenOut","in");
    N1.add_coupling("Queue","out","QueOut","in");
    N1.add_coupling("Server","out","SrvOut","in");

    root = rootcoordinator("root",0,tend,N1,0);
    root.sim();

    % plot results
    figure
    subplot(3,1,1)
    stem(simout.genOut.t,simout.genOut.y); grid on;
    xlim([0 tend]);
    xlabel("simulation time");
    ylabel("out");
    title("Generator");

    subplot(3,1,2)
    stem(simout.queOut.t,simout.queOut.y); grid on;
    xlim([0 tend]);
    xlabel("simulation time");
    ylabel("out");
    title("Queue");

    subplot(3,1,3)
    stem(simout.srvOut.t,simout.srvOut.y); grid on;
    xlim([0 tend]);
    xlabel("simulation time");
    ylabel("out");
    title("Server");
    
    out = simout;
end