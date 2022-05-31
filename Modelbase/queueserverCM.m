function N = queueserverCM(name, tS, debug)
%% Description
%  coupledDEVS combining queue and server
%% Ports
%  inputs: 
%    in   incoming entities
%  outputs: 
%    out  outgoing entities
%    n    total number of entities in queue and server
%% Parameters
%  name:  object name
%  tS: service time
%  debug: flag to output debugging infos
nQueue = name + "/Queue";
nServer = name + "/Server";
nAdd2 = name + "/Add2";
ntowsqueueout = name + "_towsqueueout";
ntowsqueuenq = name + "_towsqueuenq";
ntowsserverout = name + "_towsserverout";
ntowsserverworking = name + "_towsserverworking";
ntowsservern = name + "_towsservern";
ntowsaddout = name + "_towsaddout";

%Queue = devs(queueNOut(nQueue, debug));
Queue = devs(queue_dj(nQueue, debug));
Server = devs(server(nServer, tS, debug));
Add2 = devs(add2(nAdd2, debug));
towsqueueout = devs(toworkspace(ntowsqueueout, ntowsqueueout, 0));
towsqueuenq = devs(toworkspace(ntowsqueuenq, ntowsqueuenq, 0));
towsserverout = devs(toworkspace(ntowsserverout, ntowsserverout, 0));
towsserverworking = devs(toworkspace(ntowsserverworking, ntowsserverworking, 0));
towsservern = devs(toworkspace(ntowsservern, ntowsservern, 0));
towsaddout = devs(toworkspace(ntowsaddout, ntowsaddout, 0));

N = coordinator(name);
N.add_model(Queue);
N.add_model(Server);
N.add_model(Add2);
N.add_model(towsqueueout);
N.add_model(towsqueuenq);
N.add_model(towsserverout);
N.add_model(towsserverworking);
N.add_model(towsservern);
N.add_model(towsaddout);

N.add_coupling(name,"in",nQueue,"in");
N.add_coupling(nServer,"out",name,"out");
N.add_coupling(nAdd2,"out",name,"n");
N.add_coupling(nQueue,"out",nServer,"in");
N.add_coupling(nQueue,"nq",nAdd2,"in2");
N.add_coupling(nServer,"working",nQueue,"bl");
N.add_coupling(nServer,"n",nAdd2,"in1");

N.add_coupling(nAdd2,"out",ntowsaddout,"in");
N.add_coupling(nServer,"out",ntowsserverout,"in");
N.add_coupling(nQueue,"out",ntowsqueueout,"in");
N.add_coupling(nQueue,"nq",ntowsqueuenq,"in");
N.add_coupling(nServer,"working",ntowsserverworking,"in");
N.add_coupling(nServer,"n",ntowsservern,"in");