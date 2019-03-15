function table_output = assessment_compute(N_list, c, s0, s00, s_range, p, common_code)

%% compute 
% 1. compute threshold
addpath(common_code)
[Beta_all, Computation_all] = threshold_compute(N_list, s_range, p, c, s0, s00);

N = max(N_list);
% 2a. bias and omission
beta_threshold = Beta_all(:,:,N);
[overall_bp, each_bp] = bias_omission(beta_threshold, s_range, p, s0, s00);

% 2b. welfare and action probability
super_indicator = 1;
[frequency, welfare_unrestricted] = beta_welfare(beta_threshold, N, s_range, p, s0, s00, c, super_indicator);

% 2c. welfare with fixed t_stat
 welfare_restricted = tstat_maxwelfare(N, s_range, p, s0, s00, c);

 %% compile statistics
 table_output = zeros(8,1);
 table_output(1,1) = overall_bp(1,2);
 table_output(2,1) = each_bp(1,2);
 table_output(3,1) = each_bp(10,2);
 table_output(4,1) = overall_bp(1,1);
 table_output(5,1) = each_bp(1,1);
 table_output(6,1) = each_bp(10,1);
 table_output(7,1) = welfare_unrestricted;
 table_output(8,1) = welfare_restricted;
 

end