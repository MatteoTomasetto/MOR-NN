%% Definition of the Problem
clear

problem = problem_get('heat_equation','heat.ini');

HFmod = problem.get_model(problem);

clear optGen_base

optGen_base.do_plot = 1;
optGen_base.do_save = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate random training set
rng('default')
optGen = optGen_base;

optGen.outFile = 'train.mat';
dataset_generate_random(HFmod,100,optGen);

%% Generate random validation set
rng('default')
optGen = optGen_base;

optGen.outFile = 'validation.mat';
dataset_generate_random(HFmod,50,optGen);


%% Generate random test set
rng('default')
optGen = optGen_base;

optGen.outFile = 'test.mat';
dataset_generate_random(HFmod,50,optGen);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate Fourier training set

rng('shuffle')
optGen = optGen_base;

optGen.outFile = 'train_Fourier.mat';
dataset_Fourier = generate_dataset(problem, 100, 'Fourier'); %If T!=1, change manually the basis in generate_dataset
dataset_generate(HFmod,dataset_Fourier,optGen);

%% Generate Fourier validation set

rng('shuffle')
optGen = optGen_base;

optGen.outFile = 'validation_Fourier.mat';
dataset_Fourier = generate_dataset(problem, 50, 'Fourier'); %If T!=1, change manually the basis in generate_dataset
dataset_generate(HFmod,dataset_Fourier,optGen);

%% Generate Fourier test set

rng('shuffle')
optGen = optGen_base;

optGen.outFile = 'test_Fourier.mat';
dataset_Fourier = generate_dataset(problem, 50, 'Fourier'); %If T!=1, change manually the basis in generate_dataset
dataset_generate(HFmod,dataset_Fourier,optGen);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Generate Polynomial training set

rng('shuffle')
optGen = optGen_base;

optGen.outFile = 'train_polynomial.mat';
dataset_Fourier = generate_dataset(problem, 100, 'Polynomial');
dataset_generate(HFmod,dataset_Fourier,optGen);

%% Generate Polynomial validation set

rng('shuffle')
optGen = optGen_base;

optGen.outFile = 'validation_polynomial.mat';
dataset_Fourier = generate_dataset(problem, 50, 'Polynomial');
dataset_generate(HFmod,dataset_Fourier,optGen);

%% Generate Polynomial test set

rng('shuffle')
optGen = optGen_base;

optGen.outFile = 'test_polynomial.mat';
dataset_Fourier = generate_dataset(problem, 50, 'Polynomial');
dataset_generate(HFmod,dataset_Fourier,optGen);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


