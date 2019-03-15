KS_sort = zeros(N_simnull,N_sim);
for i1=1:N_sim
    KS_sort0 = KS_sim(i1,:)';
    KS_sort(:,i1)=sortrows(KS_sort0,1);
end
index = ceil(0.95*N_simnull);
avg_criticalKS = sum(KS_sort(index,:),2)/N_sim;