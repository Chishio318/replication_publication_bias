N_sim = size(param_sim,1);
N_insig = size(beta_insig,1);
beta_sim = [stem_param(1,1); param_sim(:,1)]; 
se_sim = [stem_param(1,3); param_sim(:,2)]; 

cdf_counterfactual=zeros(N_sim+1,N_bin);
for i1=1:N_sim+1
    mean_hat = beta_sim(i1,1);
    sigma_hat = se_sim(i1,1);
    
    cdf_original = zeros(N_insig,N_bin);
    cdf_truncated = zeros(N_insig,N_bin);
    cdf_threshold = zeros(N_insig,1);
    
    sigma_combined = sqrt(se_insig.^2 + sigma_hat^2);
    
    for j1=1:N_insig
        cdf_threshold(j1,1) = normcdf(t_threshold*se_insig(j1,1),mean_hat,sigma_combined(j1,1));
        for j2=1:N_bin
            cdf_original(j1,j2) = normcdf(beta_range(1,j2),mean_hat,sigma_combined(j1,1));
            cdf_truncated(j1,j2) = min(cdf_original(j1,j2)/cdf_threshold(j1,1),1);
        end
    end
    
    cdf_counterfactual(i1,:) = sum(cdf_truncated,1)/N_insig;
end
 
%empirical cdf
cdf_empirical = zeros(1,N_bin);
for i=1:N_bin
    cdf0 = (beta_insig<=beta_range(1,i));
    cdf_empirical(1,i) = sum(cdf0,1)/N_insig;
end