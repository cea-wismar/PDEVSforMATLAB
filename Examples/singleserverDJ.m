%function singleserver()
global simout
global epsilon
global DEBUGLEVEL
simout = [];
DEBUGLEVEL = 1;           % simulator debug level
epsilon = 1e-6;

nG = 100;
tG = 1;
tS = 1.5;
%tEnd = 15;
tEnd = 5;
mdebug = true;

N1 = coordinator('N1');

Generator = devs(generator1("Generator", tG, 1, nG, mdebug));
ToWorkspace1 = devs(toworkspace('Toworkspace1','Generator',0));
Queue = devs(queue("Queue", mdebug));
ToWorkspace2 = devs(toworkspace('Toworkspace2','Queue',0));
Server = devs(server("Server", tS, mdebug));
ToWorkspace3 = devs(toworkspace('Toworkspace3','Serverout',0));
ToWorkspace4 = devs(toworkspace('Toworkspace4','Serverbl',0));
Terminator = devs(terminator("Terminator"));

N1.add_model(Generator);
N1.add_model(Queue);
N1.add_model(Server);
N1.add_model(Terminator);
N1.add_model(ToWorkspace1);
N1.add_model(ToWorkspace2);
N1.add_model(ToWorkspace3);
N1.add_model(ToWorkspace4);

N1.add_coupling("Generator","out","Queue","in");
N1.add_coupling("Queue","out","Server","in");
N1.add_coupling("Server","out","Terminator","in");
N1.add_coupling("Server","working","Queue","bl");

N1.add_coupling("Generator","out","Toworkspace1","in");
N1.add_coupling("Queue","out","Toworkspace2","in");
N1.add_coupling("Server","out","Toworkspace3","in");
N1.add_coupling("Server","working","Toworkspace4","in");

root = rootcoordinator("root",0,tEnd,N1,0);
root.sim();


figure
subplot(4,1,1)
stem(simout.Generator.t,simout.Generator.y); grid on;
xlim([0 tEnd]);
xlabel("simulation time");
ylabel("out");
title("Generator");

subplot(4,1,2)
stem(simout.Queue.t,simout.Queue.y); grid on;
xlim([0 tEnd]);
xlabel("simulation time");
ylabel("out");
title("Queue");

subplot(4,1,3)
stem(simout.Serverout.t,simout.Serverout.y); grid on;
xlim([0 tEnd]);
xlabel("simulation time");
ylabel("out");
title("Server out");

subplot(4,1,4)
stairs(simout.Serverbl.t,simout.Serverbl.y); grid on;
xlim([0 tEnd]);
ylim([0 1.1]);
xlabel("simulation time");
ylabel("out");
title("Server working");