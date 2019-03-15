function [overall_bp, each_bp] = bias_omission(beta, s, p, s0, s00)

S = size(s,2);
y = zeros(S,2);

for i=1:S
    sigma = sqrt(s(1,i)^2+s0^2+s00^2);
    prob = normcdf(beta(i,1),0,sigma) - normcdf(beta(i,2),0,sigma);
    bias = sigma*(normpdf(beta(i,1),0,sigma) - normpdf(beta(i,2),0,sigma))/(1-prob);
    y(i,:) = [prob, bias];
    up = 1-normcdf(beta(i,1),0,sigma);
    down = normcdf(beta(i,2),0,sigma);
end

overall_bp = p*y;
each_bp = y;


end