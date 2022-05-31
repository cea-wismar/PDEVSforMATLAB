function testGenerator1()
global simout
global epsilon
global DEBUGLEVEL
simout = [];
DEBUGLEVEL = 0;           % simulator debug level
epsilon = 1e-6;

tG = 1.0;
n0 = 3;
nG = 5;
tEnd = 10;
mdebug = false;               % model debug level

N1 = coordinator('N1');

Generator = devs(generator1("Generator", tG, n0, nG, mdebug));
Genout = devs(toworkspace("Genout", "genOut", 0));
Terminator = devs(terminator("Terminator"));

N1.add_model(Generator);
N1.add_model(Terminator);
N1.add_model(Genout);

N1.add_coupling("Generator","out","Terminator","in");
N1.add_coupling("Generator","out","Genout","in");

root = rootcoordinator("root",0,tEnd,N1,0);
root.sim();

figure
stem(simout.genOut.t,simout.genOut.y); grid on;
xlim([0 tEnd]);
xlabel("simulation time");
ylabel("out_p");
title("pipe");