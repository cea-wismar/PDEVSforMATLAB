function testServer()
global simout
global epsilon
global DEBUGLEVEL
simout = [];
DEBUGLEVEL = 0;           % simulator debug level
epsilon = 1e-6;

%tG = 2.0;
tG = 1.0;
tS = 1.5;
tEnd = 10;
mdebug = false;               % model debug level

N1 = coordinator('N1');

Generator = devs(generator("Generator", tG));
Server = devs(server("Server", tS, mdebug));
Terminator = devs(terminator("Terminator"));
GenOut = devs(toworkspace("GenOut", "genOut", 0));
SrvOut = devs(toworkspace("SrvOut", "srvOut", 0));

N1.add_model(Generator);
N1.add_model(Server);
N1.add_model(Terminator);
N1.add_model(GenOut);
N1.add_model(SrvOut);

N1.add_coupling("Generator","out","Server","in");
N1.add_coupling("Server","out","Terminator","in");
N1.add_coupling("Generator","out","GenOut","in");
N1.add_coupling("Server","out","SrvOut","in");

root = rootcoordinator("root",0,tEnd,N1,0);
root.sim();

% plot results
figure
subplot(2,1,1)
stem(simout.genOut.t,simout.genOut.y); grid on;
xlim([0 tEnd]);
xlabel("simulation time");
ylabel("out");
title("Generator");

subplot(2,1,2)
stem(simout.srvOut.t,simout.srvOut.y); grid on;
xlim([0 tEnd]);
xlabel("simulation time");
ylabel("out");
title("Server");