clear all
close all

% paths
output_file = '..\..\09_output\';
common_code = '..\01_common';

% general environment
S = 10;
s_range = linspace(0.1,1,S);
s_max=4;
df=2;
addpath(common_code)
p_range = chi2p_var(s_range, df,s_max);
N_range = [2 3];

% set each set-up's parameter as follows:
c = 1/2;
s0_A = 2;
s00_A = 1/3;
s0_B = 1/2;
s00_B = 1/3;
s0_C = 1;
s00_C = 1/5;

% compute
addpath(common_code)
tic;
[Beta_A, Computation_all_A]=threshold_compute(N_range, s_range, p_range, c, s0_A, s00_A);
toc;
tic;
[Beta_B, Computation_all_B]=threshold_compute(N_range, s_range, p_range, c, s0_B, s00_B);
toc;
tic;
[Beta_C, Computation_all_C]=threshold_compute(N_range, s_range, p_range, c, s0_C, s00_C);
toc;
% since the computation takes exceptionally long time (),
% this simulation was done separately on a computationally efficient
% computer.


%% generate figures
output_folder = '..\..\09_output\';
S = 10;
s = linspace(0.1,1,S);
load('C:\Chishio\02_Research\01_Active\01_Publication Bias\01_Input\03_numerical\replication\01_thresholds\02_figures\intermediate_data\Beta_A.mat')
load('intermediate_data/Beta_A.mat')
figure_output(Beta_A, s, output_folder, 'threshold_A', 'A', '$\frac{1}{3}$', '2')
load('intermediate_data/Beta_B.mat')
figure_output(Beta_B, s, output_folder, 'threshold_B', 'B', '$\frac{1}{3}$', '$\frac{1}{2}$')
load('intermediate_data/Beta_C.mat')
figure_output(Beta_C, s, output_folder, 'threshold_C', 'C', '$\frac{1}{5}$', '1')
