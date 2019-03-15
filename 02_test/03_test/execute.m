%% initial
clear all

% simulation parameters
N_simnull=100; 
t_threshold = 1.96;
seed_num = 100;

% buffers
buffer_G_pvalue = [0.01, 0.01];
buffer_G_figure = [0.01, 0.01];
buffer_H_pvalue = [0.05, 0.05];
buffer_H_figure = [0.05, 0.45];

% set figure output range
figN_simnull = 100;
N_bin=500;
rescalef = @(x) x;

output_file = '..\..\09_output\';

%% read cleaned data and estimates from data folder
filename1 = '..\02_intermediate_data\cleaned.csv';
union_data = csvread(filename1, 1, 0);
filename2 = '..\02_intermediate_data\simulated_param.csv';
param_sim_data = xlsread(filename2);
filename3 = '..\02_intermediate_data\main_param.csv';
stem_param_original = xlsread(filename3);

% need manual adjustment of positions with intermediate data
beta_position = 2;
se_position = 3;
classification1_position = 5;
classification2_position = 6;
unique_position = 4;

% organize
data0 = [union_data(:,beta_position), union_data(:,se_position), union_data(:,classification1_position), union_data(:,classification2_position), union_data(:,unique_position)];
param_sim = param_sim_data(:,2:3);
stem_param = stem_param_original(:,2)';

% clarify meaning of include variables
include_sig_pos=1;
include_sig_neg=0;
include_insig=0;
include_null=0;
include_all=101;
include = [include_sig_pos, include_sig_neg, include_insig, include_null, include_all];

data = sortrows(data0, 2);
[se_sig, se_insig, se_null, beta_sig, beta_insig, beta_null, pos_neg] = classify(data,include,t_threshold);


%% Kolmogorov-Smirnov test and figures

% G(sigma)
output_title = 'pconverge_G_labor';
[KS_overall_G, KS_argparam_G, avg_p_G, avg_criticalKS_G] = KS_G(N_simnull, stem_param, param_sim, se_sig, se_null, pos_neg, ...
    N_bin, rescalef, t_threshold, buffer_G_pvalue, 1, output_file, output_title);

output_title =  'pconverge_H_labor';
[KS_overall_H, KS_argparam_H, avg_p_H, avg_criticalKS_H] = KS_H(N_simnull, stem_param, param_sim, beta_insig, se_insig, ...
    N_bin, t_threshold, buffer_H_pvalue, 1, output_file, output_title);

% figures
critical_se = KS_argparam_G;
output_title = 'funnel_G';
figure_option = 0;
funnelplot_G(critical_se, seed_num, stem_param, beta_sig, se_sig, beta_null, se_null, pos_neg, ...
    t_threshold, output_file, output_title, figure_option)

critical_beta = KS_argparam_H;
output_title = 'funnel_H';
funnelplot_H(critical_beta, seed_num, stem_param, beta_sig, se_sig, beta_insig, se_insig, beta_null, se_null, pos_neg, t_threshold, output_file, output_title)

% figures for slides
output_title = 'funnel_G_step1';
figure_option = 1;
funnelplot_G(critical_se, seed_num, stem_param, beta_sig, se_sig, beta_null, se_null, pos_neg, ...
    t_threshold, output_file, output_title, figure_option)

output_title = 'funnel_G_step2';
figure_option = 2;
funnelplot_G(critical_se, seed_num, stem_param, beta_sig, se_sig, beta_null, se_null, pos_neg, ...
    t_threshold, output_file, output_title, figure_option)


%% additional codes for generating 
figKS_G(figN_simnull, stem_param, param_sim, se_sig, se_null, pos_neg, ...
     N_bin, t_threshold, buffer_G_figure, 1, output_file, 'KS_G_labor');

 figKS_H(N_simnull, stem_param, param_sim, beta_insig, se_insig, ...
     N_bin, t_threshold, buffer_H_figure, 1, output_file, 'KS_H_labor');
