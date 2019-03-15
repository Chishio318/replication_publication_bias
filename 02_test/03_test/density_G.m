N_sim = size(param_sim,1);
N_sig = size(se_sig,1);
N_null = size(se_null,1);

se_density = zeros(N_sim+1,N_sig);
beta_sim = [stem_param(1,1); param_sim(:,1)]; 
se_sim = [stem_param(1,3); param_sim(:,2)]; 

for i1=1:N_sim+1
    mean_hat = beta_sim(i1,1);
    sigma_hat = se_sim(i1,1);
     for i2=1:N_sig    
     pos_CDF = normcdf(t_threshold*se_sig(i2,1), mean_hat, sqrt(sigma_hat^2+se_sig(i2,1)^2));
     neg_CDF = normcdf(-t_threshold*se_sig(i2,1), mean_hat, sqrt(sigma_hat^2+se_sig(i2,1)^2));
     if pos_neg(1,i2)==1
        se_density(i1,i2) = (pos_CDF-neg_CDF)/(1-pos_CDF);
     elseif pos_neg(1,i2)==0
        se_density(i1,i2) = (pos_CDF-neg_CDF)/neg_CDF;
     end
     
     end
     se_density(i1,:)=se_density(i1,:)/sum(se_density(i1,:));
end