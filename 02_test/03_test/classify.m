function [se_sig, se_insig, se_null, beta_sig, beta_insig, beta_null, pos_neg] = classify(data,include,t_threshold)

beta = data(:,1);
se = data(:,2);
t_stat = beta./se;

yesno1 = data(:,3);
stat_sig1 = (yesno1==include(1,1) | yesno1>=include(1,5)).*(t_stat >= t_threshold)+(yesno1==include(1,2) | yesno1>=include(1,5)).*(t_stat < -t_threshold);
stat_insig1 = (yesno1==include(1,3) | yesno1>=include(1,5)).*(t_stat < t_threshold);
stat_null1 = (yesno1==include(1,4) | yesno1>=include(1,5)).*(t_stat < t_threshold).*(t_stat > -t_threshold);

yesno2 = data(:,4);
stat_sig2 = (yesno2==include(1,1) | yesno2>=include(1,5)).*(t_stat >= t_threshold)+(yesno2==include(1,2) | yesno2>=include(1,5)).*(t_stat < -t_threshold);
stat_insig2 = (yesno2==include(1,3) | yesno2>=include(1,5)).*(t_stat < t_threshold);
stat_null2 = (yesno2==include(1,4) | yesno2>=include(1,5)).*(t_stat < t_threshold).*(t_stat > -t_threshold);

unique = data(:,5);
stat_sig = (stat_sig1 == 1| stat_sig2 == 1);
stat_insig = (stat_insig1 == 1| stat_insig2 == 1);
stat_null = (stat_null1 == 1| stat_null2 == 1);

N = size(beta,1);
N_sig = sum(stat_sig,1);
N_insig = sum(stat_insig,1);
N_null = sum(stat_null,1);

beta_sig = zeros(N_sig,1);
se_sig = zeros(N_sig,1);
beta_insig = zeros(N_insig,1);
se_insig = zeros(N_insig,1);
beta_null = zeros(N_null,1);
se_null = zeros(N_null,1);
pos_neg = zeros(1,N_sig);
index_sig = 1;
index_insig = 1;
index_null = 1;
for i=1:N
    if stat_sig(i,1)==1
        beta_sig(index_sig, 1) = beta(i,1);
        se_sig(index_sig, 1) = se(i,1);
        pos_neg(1,index_sig) = (beta_sig(index_sig, 1)>0);
        index_sig = index_sig + 1;
    end
    if stat_insig(i,1)==1
        beta_insig(index_insig, 1) = beta(i,1);
        se_insig(index_insig, 1) = se(i,1);
        index_insig = index_insig + 1;
    end
    if stat_null(i,1)==1
        beta_null(index_null, 1) = beta(i,1);
        se_null(index_null, 1) = se(i,1);
        index_null = index_null + 1;
    end
end

end