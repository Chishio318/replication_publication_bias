function p = chi2p_var(s, df, max)

S = size(s,2);
s_axis = [s, 1+1\(S-1)];
var = max*s_axis.^2;
%rescale by max

cdf = zeros(1,S);
p = zeros(1,S);
for i=1:S;
    cdf(1,i) = chi2cdf(var(1,i+1),df);
end
p(1,1)=cdf(1,1);
for i=2:S;
    p(1,i) = cdf(1,i)-cdf(1,i-1);
end

end
