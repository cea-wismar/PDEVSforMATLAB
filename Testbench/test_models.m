function tests = test_models
	tests = functiontests(localfunctions);
end

%Run the models in the Examplex directory and compare the results 
%with the saved results.
%
%run with: run(test_models)

function test_model1(testCase)

	act_out = model1(10);
	load('model1_out.mat');
	verifyEqual(testCase, act_out, model1_out)
	close all;
end

function test_model2(testCase)

	act_out = model2(10);
	load('model2_out.mat');
	verifyEqual(testCase, act_out, model2_out)
	close all;
end

function test_model3(testCase)

	act_out = model3(10);
	load('model3_out.mat');
	verifyEqual(testCase, act_out, model3_out)
	close all;
end

function test_model4(testCase)

	act_out = model4(10);
	load('model4_out.mat');
	verifyEqual(testCase, act_out, model4_out)
	close all;
end

function test_model5(testCase)

	act_out = model5(10);
	load('model5_out.mat');
	verifyEqual(testCase, act_out, model5_out)
	close all;
end

function test_model6(testCase)

	act_out = model6(10);
	load('model6_out.mat');
	verifyEqual(testCase, act_out, model6_out)
	close all;
end

function test_compswitch(testCase)

	act_out = compswitch(10);
	load('compswitch_out.mat');
	verifyEqual(testCase, act_out, compswitch_out)
	close all;
end

function test_fifo3(testCase)

	act_out = fifo3(80);
	load('fifo3_out.mat');
	verifyEqual(testCase, act_out, fifo3_out)
	close all;
end

function test_singleserver(testCase)

	act_out = singleserver(15);
	load('singleserver_out.mat');
	verifyEqual(testCase, act_out, singleserver_out)
	close all;
end

function test_testBingenerator(testCase)

	act_out = testBingenerator(14);
	load('testBingenerator_out.mat');
	verifyEqual(testCase, act_out, testBingenerator_out)
	close all;
end

function test_testComparator(testCase)

	act_out = testComparator(10);
	load('testComparator_out.mat');
	verifyEqual(testCase, act_out, testComparator_out)
	close all;
end

function test_testGenerator1(testCase)

	act_out = testGenerator1(10);
	load('testGenerator1_out.mat');
	verifyEqual(testCase, act_out, testGenerator1_out)
	close all;
end

function test_testJkflipflop(testCase)

	act_out = testJkflipflop(14);
	load('testJkflipflop_out.mat');
	verifyEqual(testCase, act_out, testJkflipflop_out)
	close all;
end

function test_testNotgate(testCase)

	act_out = testNotgate(14);
	load('testNotgate_out.mat');
	verifyEqual(testCase, act_out, testNotgate_out)
	close all;
end

function test_testQueueServerCM(testCase)

	act_out = testQueueServerCM(9);
	load('testQueueServerCM_out.mat');
	verifyEqual(testCase, act_out, testQueueServerCM_out)
	close all;
end

function test_testServer(testCase)

	act_out = testServer(10);
	load('testServer_out.mat');
	verifyEqual(testCase, act_out, testServer_out)
	close all;
end

function test_testShiftregister(testCase)

	act_out = testShiftregister(15);
	load('testShiftregister_out.mat');
	verifyEqual(testCase, act_out, testShiftregister_out)
	close all;
end

function test_testVectorgen(testCase)

	act_out = testVectorgen(10);
	load('testVectorgen_out.mat');
	verifyEqual(testCase, act_out, testVectorgen_out)
	close all;
end