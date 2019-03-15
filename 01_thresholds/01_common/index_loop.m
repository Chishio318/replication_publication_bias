function y = index_loop(S, K)
%input should be N-1

Y = zeros(S^K, K);

for i=1:K
    col_unit = [];
    for j=1:S
        col_unit = [col_unit; j*ones(S^(i-1),1)];
    end
    repeatN = S^(K-i);
    Y(:,i) = repmat(col_unit, repeatN, 1);
end

y = Y;
end
