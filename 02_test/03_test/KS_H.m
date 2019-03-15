function [KS_overall, KS_argparam, avg_p, avg_criticalKS] = KS_H(N_simnull, stem_param, param_sim, beta_insig, se_insig, N_bin, t_threshold, buffer, empcount, output_folder, output_title)
%% CDF
beta_min = min(beta_insig) - buffer(1,1);
beta_max = max(beta_insig) + buffer(1,2);
beta_range = linspace(beta_min,beta_max, N_bin);
cdf_H

%% KS-stat
KS = zeros(N_sim+1,1);
KS_ind = zeros(N_sim+1,1);
for i=1:N_sim+1
    diff = empcount*(cdf_empirical - cdf_counterfactual(i,:));
    % switched order
    [sup_diff0, sup_ind0] = max(diff);
    KS(i,1) = sup_diff0;
    KS_ind(i,1) = sup_ind0;
end
KS_overall = KS(1,1);
KS_argparam = beta_range(1,KS_ind(1,1));

%% p-value

%sampling under densities
simnull_beta=zeros(N_sim,N_simnull,N_insig);
simnull_rand=rand(N_sim,N_simnull,N_insig);
 
cdf_empirical_sim = zeros(N_sim,N_simnull,N_bin);
KS_sim = zeros(N_sim,N_simnull);
KS_indsim = zeros(N_sim,N_simnull);

for i1=1:N_sim
    for i2=1:N_simnull
        for i3=1:N_insig
            lessthan = (cdf_counterfactual(i1+1,:)<=simnull_rand(i1,i2,i3));
            index = sum(lessthan, 2);
            if index>0
                simnull_beta(i1,i2,i3) = beta_range(1,index);
            elseif index==0
                simnull_beta(i1,i2,i3) = beta_range(1,1);
            end
        end
        
        for i3=1:N_bin
            lessthan = (simnull_beta(i1,i2,:) <= beta_range(1,i3));
            cdf_empirical_sim(i1,i2,i3) = sum(lessthan)/N_insig;
        end
        
        %dummy to match the dimension for arithmatic operation
        cdf_dummy = zeros(1,1,N_bin);
        cdf_dummy(1,1,:) = cdf_counterfactual(i1+1,:);
        diff = empcount*(cdf_empirical_sim(i1,i2,:) - cdf_dummy(1,1,:));
        [sup_diff0, sup_ind0] = max(diff);
        KS_sim(i1,i2) = sup_diff0;
        KS_indsim(i1,i2) = sup_ind0;
    end
end

p = zeros(N_sim, 1);
for i=1:N_sim
    largerthan = (KS(i+1,1)<=KS_sim(i,:));
    p(i,1) = sum(largerthan,2)/N_simnull;
end
avg_p = sum(p,1)/N_sim;

avg_KS
p_convergence

end