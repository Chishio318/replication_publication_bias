function welfare = tstat_maxwelfare(N, s, p, s0, s00, c)

% search setup
N_sim = 100;
t_list = linspace(0,5,N_sim);
% the range and precision of search is somewhat arbitrary,
% but a few rounds of trials and errors have shown that these
% values generate sufficiently precise output.

% compute
welfare_list = zeros(1,N_sim);

for i=1:N_sim
    t_threshold=t_list(1,i);
    [posterior, frequency, welfare] = tstat_welfare(t_threshold, N, s, p, s0, s00, c);
    welfare_list(1,i) = welfare;
end

welfare = max(welfare_list);

end