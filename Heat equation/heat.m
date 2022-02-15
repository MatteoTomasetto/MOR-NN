%% Definition of the Problem
clear

problem = problem_get('heat_equation','heat.ini');

HFmod = problem.get_model(problem);

clear optGen_base

optGen_base.do_plot = 1;
optGen_base.do_save = 1;
optGen = optGen_base;

%% Model learning
dir = model_learn('opt_heat.ini'); 
  
%% ANN model loading
ANNmod = read_model_fromfile(problem,'test_int_N3_hlayF10_dof163_ntrain200_2021-05-05_16-54-06');
ANNmod.visualize()

%% ANN model test
test_solve.tt = [0 5]; %set time interval
test_solve.uu = @(t) [sin(t)+20;sin(t)+20;sin(t)+20;...
                      sin(t)+20;sin(t)+20;sin(t)+20;...
                      sin(t)+20;sin(t)+20;sin(t)+20]; %set nU time-dependent input
figure();
output_HF = model_solve(test_solve,HFmod,struct('do_plot',1));
figure();
output_ANN = model_solve(test_solve,ANNmod,struct('do_plot',1));

%% Error evaluation
dataset_def.problem = problem;
dataset_def.type = 'file';
dataset_def.source = 'test_Fourier_T5.mat|test_polynomial_T5.mat';
test_dataset = dataset_get(dataset_def); 
%model_compute_error(HFmod, test_dataset);
model_compute_error(ANNmod, test_dataset);
model_compute_error(ANNmod, test_dataset, optGen);
