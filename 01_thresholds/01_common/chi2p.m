function y = chi2p(S_v, chidf)
% I try to approximate some natural distribution of Chi2 distribution. I
% chose d.f.5, which produced intuitive distribution.

prob = zeros(1,S_v);

for i=1:S_v;
    prob(1,i) = chi2pdf(i,chidf);
end
y = prob/sum(prob);

end
