function [count, posterior, frequency] = beta_posterior(beta_threshold, N, s, p, s0, s00, c)


%% sim param
R = 5*10^5;
initial_seed = 1;
 
%% function
rng(initial_seed);
% sample sigma
s_seed = rand(R,N);
S = size(s,2);
s_cdf = zeros(1,S);
s_cdf(1,1) = p(1,1);
for i=2:S
    s_cdf(1,i) = p(1,i) + s_cdf(1,i-1);
end
 
lessthan = zeros(R,N,S);
for  i=1:S
    lessthan(:,:,i) = (s_seed < s_cdf(1,i));
end
s_index = S-sum(lessthan, 3)+1;
 
% sample beta
b = normrnd(0,s0,[R 1]);
epsilon = normrnd(0,1,[R N]);
 
Beta = zeros(R, N);
Sigma = zeros(R,N);
messages = zeros(R,N);
for i1=1:R
    for i2=1:N
        Sigma(i1,i2) = s(1,s_index(i1,i2));
        s_combined = sqrt(Sigma(i1,i2)^2 + s00^2);
        Beta(i1,i2) = b(i1,1) + s_combined*epsilon(i1,i2);
        if Beta(i1,i2)>beta_threshold(s_index(i1,i2),1)
            messages(i1,i2) = 1;
        elseif Beta(i1,i2)<=beta_threshold(s_index(i1,i2),1) && Beta(i1,i2)>beta_threshold(s_index(i1,i2),2)
            messages(i1,i2) = 0;
        elseif Beta(i1,i2)<=beta_threshold(s_index(i1,i2),2)
            messages(i1,i2) = -1;
        end
    end
end

Inv_var = 1./(Sigma.^2 + s00^2);
Eb = sum(Beta.*Inv_var,2)./(sum(Inv_var,2)+1/s0^2)-c;

N1 = N+1;
posterior = zeros(N1,N1);
count = zeros(N1,N1);
n0n1 = zeros(R,2);

count0 = (messages(:,:)==-1);
n0n1(:,1) = sum(count0,2);
count1 = (messages(:,:)==1);
n0n1(:,2) = sum(count1,2);
    
for i2=0:N
    for i3=0:N
        apply = (n0n1(:,1)==i2 & n0n1(:,2)==i3);
        count(i2+1,i3+1) = sum(apply,1);
        posterior(i2+1,i3+1) = Eb'*apply/count(i2+1,i3+1);
    end
end

action = (n0n1(:,2)>n0n1(:,1)); %supermajoritarian rule
fullinfo_action = (Eb>0);
welfare = Eb'*action/R;
fullinfo_welfare = Eb'*fullinfo_action/R;
welfare_percent = welfare/fullinfo_welfare;
frequency = sum(action,1)/R;

end
