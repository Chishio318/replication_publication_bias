clear all
close all

% paths
output_file = '..\..\09_output\';
common_code = '..\01_common';

% environment
S = 10;
s_range = linspace(0.1,1,S);
s_max=4;
df=2;
p_range = chi2p_var(s_range, df,s_max);

% set range parameter as follows:
N_range = 2;
c_range = 1/2;
s0_range = 1/3;
s00_range = 1/2;

% compute
addpath(common_code)
tic;
[Beta_all, Computation_all]=threshold_compute(N_range, s_range, p_range, c_range, s0_range, s00_range);
toc;

% plot
output_title = 'convex';
fig = figure;
plot(s_range,Beta_all(:,1,1),'--','Color',[0.2 0.6 0.8],'LineWidth',1.5)
hold on 
plot(s_range,Beta_all(:,1,2),'Color',[0.2 0.4 0.8],'LineWidth',1.5)
hold on 
plot(s_range,Beta_all(:,2,2),'Color',[0.2 0 0.8],'LineWidth',1.5)

xlabel('$\sigma_{i}$','Interpreter','latex', 'FontSize', 12)
ylabel('$\beta_{i}$','Interpreter','latex', 'FontSize', 12)
title(['Equilibrium thresholds with $c=\frac{1}{2}$'],'Interpreter','latex', 'FontSize', 12)
h = legend('$\overline{\beta}\left(\sigma\right)=\underline{\beta}\left(\sigma\right)$ for $N=1$', ...
                  '$\overline{\beta}\left(\sigma\right)$ for $N=2$','$\underline{\beta}\left(\sigma\right)$ for $N=2$', ...
                  'Location', 'northwest');
set(h,'Interpreter','latex', 'FontSize', 10)
saveas(fig, strcat(output_file, output_title), 'png');
