clear all
close all

% paths
output_file = '..\..\09_output\';
common_code = '..\01_common';
figures_code = '..\02_figures';
simulation_code = '..\03_simulation';

%% Figures
addpath(figures_code)

% Figure 2 thresholds
beta_upperbar_and_beta_lowerbar

% Figure B2 likelihood of policy implementation
policy_likelihood

% Figure B3 optimality of supermajoritarian voting rule
supermajoritarian_optimality

% Figure B4 convex threshold
convex_threshold

% Figure B5 consistency of posterior
plot_posterior

% Figure B6 many N
high_N

%% Simulation
addpath(simulation_code)
run
