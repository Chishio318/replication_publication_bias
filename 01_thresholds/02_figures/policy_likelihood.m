% environment
bin = 10;
N_range = 2;
c_range = 0;
s_range = linspace(0.1, 5, bin)';
p_range = 1*ones(bin,1);
s0_range = 1;
s00_range = 0;

% compute
[Beta_all, Computation_all]=threshold_compute(N_range, s_range, p_range, c_range, s0_range, s00_range);

% frequency of a=1
freq = zeros(bin, 1);
N = 2;

for is=1:bin
s = s_range(is,1);
p = 1;
beta_threshold = Beta_all(:,:,2,1,is);
[count, posterior, frequency] = beta_posterior(beta_threshold, N, s, p, s0_range, s00_range, c_range);
freq(is,1) = frequency;
end

compare = 0.5*ones(1,bin);

figure
plot(s_range,freq,'Color',[0.2 0.4 0.8],'LineWidth',1.5)
hold on
plot(s_range,compare,'Color',[0.6 0.6 0.6],'LineWidth',1.5)
ylim([0.48 0.51])
xlabel('Standard deviation of signal $\sigma$','Interpreter','latex', 'FontSize', 12)
ylabel('$\bf{P}$ $\left(a^{\ast}=1\right)$','Interpreter','latex', 'FontSize', 12)
title(['Probability of policy implementation'],'Interpreter','latex', 'FontSize', 12)
h = legend('Equilibrium probability','Full information probability ($\frac{1}{2}$)', ...
                  'Location', 'southwest');
set(h,'Interpreter','latex', 'FontSize', 10)
