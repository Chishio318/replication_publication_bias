function [y, z] = Eb(beta,i,b,B0,epsilon,M,P,Q,v,r)

K = size(M,2); %=N-1
S = size(v,2);
if K==1
Ebsigma = zeros(S,1);
Qi = zeros(S,1);
Pi = zeros(S,1);
Piv = zeros(S,1);
else
Ebsigma = zeros(S*ones(1,K));
Qi = zeros(S*ones(1,K));
Pi = zeros(S*ones(1,K));
Piv = zeros(S*ones(1,K));
end

J = index_loop(S, K);
for j=1:size(J, 1)
    sigma = [i J(j,:)];
    [Ebsigma(j), Piv(j)]= Ebs(beta,b,sigma,B0,epsilon,M,v,r);
    Qi(j) = Q(i,j)*Piv(j);
    Pi(j) = P(i,j)*Piv(j);
    % j indexes J(j,:)
end

Prob_Piv = sum(reshape(Pi,1,S^K),2);
Prob_var_Piv = Qi/Prob_Piv;
z = v(1,i)/sum(reshape(Prob_var_Piv,1,S^K),2);
QEb = Prob_var_Piv.*Ebsigma;
y = sum(reshape(QEb,1,S^K),2);


end