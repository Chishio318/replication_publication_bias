se_range=linspace(se_min,se_max,N_bin);
cdf_counterfactual = zeros(N_sim+1,N_bin);
for i1=1:N_sim+1
    for i2=1:N_bin
        cdf0 = (se_sig<=se_range(1,i2));
        cdf_counterfactual(i1,i2)=se_density(i1,:)*cdf0;
    end
end
 
cdf_empirical=zeros(1,N_bin);
for i=1:N_bin
    cdf0 = (se_null<=se_range(1,i));
    cdf_empirical(1,i)=sum(cdf0,1)/N_null;
end
