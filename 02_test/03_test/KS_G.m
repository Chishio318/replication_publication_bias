function [KS_overall, KS_argparam, avg_p, avg_criticalKS] = KS_G(N_simnull, stem_param, param_sim, se_sig, se_null, pos_neg, N_bin, rescalef, t_threshold, buffer, empcount, output_folder, output_title)

%% CDF

density_G
se_sig=rescalef(se_sig);
se_null=rescalef(se_null);
se_min=min(se_sig(1,1), se_null(1,1))-buffer(1,1);
se_max =max(se_sig(N_sig,1),se_null(N_null,1))-buffer(1,2);
cdf_G

%% KS-stat
KS = zeros(N_sim+1,1);
KS_ind = zeros(N_sim+1,1);
for i=1:N_sim+1
    cdf_diff =  empcount*(cdf_empirical - cdf_counterfactual(1,:));
    [sup_diff0, sup_ind0] = max(cdf_diff);
    KS(i,1) = sup_diff0;
    KS_ind(i,1) = sup_ind0;
end

KS_overall = KS(1,1);
KS_argparam = se_range(1,KS_ind(1,1));
%% p-value
simnull_rand=rand(N_sim,N_simnull,N_null);
simnull_se = zeros(N_sim,N_simnull,N_null);
 
cdf_empirical_sim = zeros(N_sim,N_simnull,N_bin);
KS_sim = zeros(N_sim,N_simnull);
KS_indsim = zeros(N_sim,N_simnull);


for i1=1:N_sim
    for i2=1:N_simnull
        for i3=1:N_null
            lessthan = (cdf_counterfactual(i1,:)<=simnull_rand(i1,i2,i3));
            index = sum(lessthan,2);
            simnull_se(i1,i2,i3) = se_range(1,index);
        end
    end
end
 

for i1=1:N_sim
    for i2=1:N_simnull
        for i3=1:N_bin
            lessthan = (simnull_se(i1,i2,:) <= se_range(1,i3));
            cdf_empirical_sim(i1,i2,i3) = sum(lessthan)/N_null;
        end
        
        cdf_counterfactual2 = zeros(1,1,N_bin);
        cdf_counterfactual2(1,1,:) = cdf_counterfactual(i1,:);
        diff = empcount*(cdf_empirical_sim(i1,i2,:) -cdf_counterfactual2(1,1,:));
        [sup_diff0, sup_ind0] = max(diff);
        KS_sim(i1,i2) = sup_diff0;
        KS_indsim(i1,i2) = sup_ind0;
   end
end
 
p = zeros(N_sim,1);
for i=2:N_sim+1
    largerthan = (KS(i)<=KS_sim(i-1,:));
    p(i,1) = sum(largerthan,2)/N_simnull;
end
avg_p = sum(p,1)/N_sim;

avg_KS
p_convergence

end


