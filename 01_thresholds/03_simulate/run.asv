clear all
close all

% paths
common_code = '..\01_common';

% general environment
S = 10;
s_range = linspace(0.1,1,S);
s_max=4;
df=2;
addpath(common_code)
p = chi2p_var(s_range, df,s_max);

% compute 
N_default = 2;
c_default = 0;
s0_default = 0.1;
s00_default = 1/4;

% N_alt = [2, 3];
% output_N = assessment_compute(N_alt, c_default, s0_default, s00_default, s_range, p, common_code);


%% compute table output
% 1: default assessment
output_default = assessment_compute(N_default, c_default, s0_default, s00_default, s_range, p, common_code);

% 2: high s00:
s00_alt = 1;
output_s00 = assessment_compute(N_default, c_default, s0_default, s00_alt, s_range, p, common_code);

% 3: high s0:
s0_alt = 1;
output_s0 = assessment_compute(N_default, c_default, s0_alt, s00_default, s_range, p, common_code);

% 4: high c:
c_alt = 0.05;
output_c = assessment_compute(N_default, c_alt, s0_default, s00_default, s_range, p, common_code);

% 5: high N:
N_alt = [2, 3];
output_N = assessment_compute(N_alt, c_default, s0_default, s00_default, s_range, p, common_code);

% table_together = [output_default, output_s00, output_s0, output_c];
table_together = [output_default, output_s00, output_s0, output_c, output_N];