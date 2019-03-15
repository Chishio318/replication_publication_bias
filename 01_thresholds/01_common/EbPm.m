function [Ebeta, Pbeta] = EbPm(beta,b,sigma,B0,epsilon,m,v,r)

K = size(sigma,2)-1; %=N-1
rB = zeros(size(B0,1),K);
s1 = sigma(1,1); %index
A = zeros(size(B0,1),K);
iV = zeros(1,K);
s = v.^0.5;

for i=1:K
    
% modify random B
    si = sigma(1,i+1);
    rB(:,i) = r(si,s1)*(s(1,si)/s(1,s1))*beta... % d+1 is an inverse mapping from n' to b thresholds
                +s(1,si)*epsilon(:,i)+B0(:,s1);
                      
% policy matrix A
    if m(1,i)== 1
        A(:,i) = rB(:,i)>b(sigma(1,i+1),1,i); %shift in index' meaning
    elseif m(1,i)== 0
        A(:,i) = rB(:,i)<b(sigma(1,i+1),1,i)...
                & rB(:,i)>b(sigma(1,i+1),2,i);
    elseif m(1,i)== -1 
        A(:,i) = rB(:,i)<b(sigma(1,i+1),2,i);
    end

% inverse of variance
    iV(i)=1/s(1,sigma(1,i+1))^2; %shift in index' meaning
    
end

% output
a = prod(A,2); %a=1 iff A=1 for all
wrB = rB.*(a*iV); %only for a=1
total_a = sum(a,1);
if total_a>0
Ebeta = sum(sum(wrB, 2),1)/total_a;
else
    Ebeta = 0;
end
Pbeta = sum(a,1)/size(a,1);

end