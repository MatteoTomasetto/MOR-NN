%% Definition of the Problem
clear

problem = problem_get('NavierStokes_equation','NavierStokes.ini');

HFmod = problem.get_model(problem);

clear optGen_base

optGen_base.do_plot = 1;
optGen_base.do_save = 1;
optGen_base.one_sample_per_time = 1;
optGen = optGen_base;
%optGen.freq_save = 1;
%optGen.append = 0;
%optGen.save_x_dt = 10;
%optGen.save_x = 1;
%optGen.pause_eachtest = 0;
%optGen.optRandomU.time_scale = 1;

%optGen.constant = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate random training set
rng('shuffle')
 
optGen.outFile = 'train.mat';
dataset_generate_random(HFmod,100,optGen);

%% Generate random validation set
rng('shuffle')

optGen.outFile = 'validation.mat';
dataset_generate_random(HFmod,50,optGen);


%% Generate random test set
rng('shuffle')

optGen.outFile = 'test_T3.mat';
dataset_generate_random(HFmod,50,optGen);


%% Generate Fourier training set

rng('shuffle')
optGen = optGen_base;

optGen.outFile = 'train_Fourier.mat';
dataset_Fourier = generate_dataset_NS(problem, 100, 'Fourier'); %If T!=1, change manually the basis in generate_dataset
dataset_generate(HFmod,dataset_Fourier,optGen);

%% Generate Fourier validation set

rng('shuffle')
optGen = optGen_base;

optGen.outFile = 'validation_Fourier.mat';
dataset_Fourier = generate_dataset_NS(problem, 50, 'Fourier'); %If T!=1, change manually the basis in generate_dataset
dataset_generate(HFmod,dataset_Fourier,optGen);

%% Generate Fourier test set

rng('shuffle')
optGen = optGen_base;

optGen.outFile = 'test_Fourier.mat';
dataset_Fourier = generate_dataset_NS(problem, 50, 'Fourier'); %If T!=1, change manually the basis in generate_dataset
dataset_generate(HFmod,dataset_Fourier,optGen);



%% Generate Polynomial training set

rng('shuffle')
optGen = optGen_base;

optGen.outFile = 'train_polynomial.mat';
dataset_Polynomial = generate_dataset_NS(problem, 100, 'Polynomial');
dataset_generate(HFmod,dataset_Polynomial,optGen);

%% Generate Polynomial validation set

rng('shuffle')
optGen = optGen_base;

optGen.outFile = 'validation_polynomial.mat';
dataset_Polynomial = generate_dataset_NS(problem, 50, 'Polynomial');
dataset_generate(HFmod,dataset_Polynomial,optGen);

%% Generate Polynomial test set

rng('shuffle')
optGen = optGen_base;

optGen.outFile = 'test_polynomial_T3.mat';
dataset_Polynomial = generate_dataset_NS(problem, 50, 'Polynomial');
dataset_generate(HFmod,dataset_Polynomial,optGen);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Generate Jumps training set

rng('shuffle')
optGen = optGen_base;

optGen.outFile = 'train_jumps.mat';
dataset_Jumps = generate_dataset_NS(problem, 100, 'Jumps');
dataset_generate(HFmod,dataset_Jumps,optGen);

%% Generate Jumps validation set

rng('shuffle')
optGen = optGen_base;

optGen.outFile = 'validation_jumps.mat';
dataset_Jumps = generate_dataset_NS(problem, 50, 'Jumps');
dataset_generate(HFmod,dataset_Jumps,optGen);

%% Generate Jumps test set

rng('shuffle')
optGen = optGen_base;

optGen.outFile = 'test_jumps_T3.mat';
dataset_Jumps = generate_dataset_NS(problem, 50, 'Jumps');
dataset_generate(HFmod,dataset_Jumps,optGen);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

