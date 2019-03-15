function [action_rule, frequency, welfare_percent] = tstat_welfare(t_threshold, N, s, p, s0, s00, c)

%% sim param
R = 5*10^4;
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

for i1=1:R
    for i2=1:N
        Sigma(i1,i2) = s(1,s_index(i1,i2));
        s_combined = sqrt(Sigma(i1,i2)^2 + s00^2);
        Beta(i1,i2) = b(i1,1) + s_combined*epsilon(i1,i2);
    end
end

tratio = Beta./Sigma;
message = (tratio>t_threshold);
count1 = sum(message, 2);
Inv_var = 1./(Sigma.^2 + s00^2);
Eb = sum(Beta.*Inv_var,2)./(sum(Inv_var,2)+1/s0^2)-c;

N1 = N+1;
posterior = zeros(N1,1);
frequency = zeros(N1,1);
for i=1:N1
    apply = (count1==i-1);
    frequency(i,1) = sum(apply,1);
    posterior(i,1) = Eb'*apply/frequency(i,1);
end

action_rule = (posterior>0);
min_message1 = N-sum(action_rule,1)+1;
action = (count1>=min_message1);
fullinfo_action = (Eb>0);
welfare = Eb'*action/R;
fullinfo_welfare = Eb'*fullinfo_action/R;
welfare_percent = welfare/fullinfo_welfare;

end



    
    



