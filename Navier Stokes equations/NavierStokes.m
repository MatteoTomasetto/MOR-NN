%% Definition of the Problem
clear

problem = problem_get('NavierStokes_equation','NavierStokes.ini');

HFmod = problem.get_model(problem);

clear optGen_base

optGen_base.do_plot = 1;
optGen_base.do_save = 1;
optGen = optGen_base;

%% Model learning
model_learn('opt_NavierStokes.ini'); 
  
%% ANN model loading
ANNmod = read_model_fromfile(problem,'test_int_N6_hlayF7_hlayG3_dof147_ntrain100_2021-07-03_17-10-42');
ANNmod.visualize()

%% ANN model test
test_solve.tt = [0 1]; %set time interval
test_solve.uu = @(t) [100 + 0.*t; sin(t)+20;t+20]; %set nU time-dependent input
figure();
output_HF = model_solve(test_solve,HFmod,struct('do_plot',1));
figure();
output_ANN = model_solve(test_solve,ANNmod,struct('do_plot',1));

%% Error evaluation
dataset_def.problem = problem;
dataset_def.type = 'file';
dataset_def.source = 'test_jumps_T3.mat';
test_dataset = dataset_get(dataset_def); 
%model_compute_error(HFmod, test_dataset);
model_compute_error(ANNmod, test_dataset);
model_compute_error(ANNmod, test_dataset, optGen);
