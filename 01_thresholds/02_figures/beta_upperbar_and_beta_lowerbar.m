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
s0_range = 0.7;
s00_range = 0;

% compute
addpath(common_code)
[Beta_all, Computation_all]=threshold_compute(N_range, s_range, p_range, c_range, s0_range, s00_range);

% run
constant = 15.1/9;
s = linspace(0,1,S+1);
t_threshold = constant*s;

include0 = 4;
include1 = 9;
x = s_range(1,include0:include1);
y1 = Beta_all(include0:include1,1,2)';
y2= t_threshold(1,include0+1:include1+1);
X = [x fliplr(x)];
Y = [y2 fliplr(y1)];
zero = zeros(S+1,1);

output_title = 'beta_upperbar_lowerbar';
fig = figure;
plot(s,[c_range; Beta_all(:,1,2)],'Color',[0.2 0 0.8],'LineWidth',1.5)
hold on
plot(s,[c_range; Beta_all(:,2,2)],'Color',[0.2 0.4 0.8],'LineWidth',1.5)
hold on
plot(s,t_threshold,'--','Color',[0.2 0.6 0.8],'LineWidth',1.5)
hold on
g = fill(X,Y,[1 0.3 0]);
set(g,'EdgeColor','None')
plot(s,zero,':','Color',[0.7 0.7 0.7],'LineWidth',1.5)
h = legend('$\overline{\beta}\left(\sigma\right)$','$\underline{\beta}\left(\sigma\right)$','$t$-statistics threshold','Region of inflation', 'Location', 'southwest');
set(h,'Interpreter','latex')
dim1 = [0.25 0.5 0.9 0.3];
str1 = {'$m_{i}=1$'};
annotation('textbox',dim1,'String',str1,'FitBoxToText','on','interpreter','latex');
dim0 = [0.3 0.15 0.9 0.3];
str0 = {'$m_{i}=0$'};
annotation('textbox',dim0,'String',str0,'FitBoxToText','on','interpreter','latex');
dime = [0.7 0.4 0.9 0.3];
stre = {'$m_{i}=\emptyset$'};
annotation('textbox',dime,'String',stre,'FitBoxToText','on','interpreter','latex');
title(['Equilibrium thresholds'],'Interpreter','latex')
xlabel('Standard error $\sigma_{i}$','Interpreter','latex')
ylabel('Coefficient $\beta_{i}$','Interpreter','latex')
saveas(fig, strcat(output_file, output_title), 'png');


%% figures for slides

output_title1 = 'beta_upperbar_lowerbar_first';
fig1 = figure;
plot(s,[c_range; Beta_all(:,1,2)],'Color',[0.2 0 0.8],'LineWidth',1.5)
hold on
plot(s,zero,':','Color',[0.7 0.7 0.7],'LineWidth',1.5)
title(['Equilibrium thresholds'],'Interpreter','latex')
ylim([-2 2])
xlabel('Standard error $\sigma_{i}$','Interpreter','latex')
ylabel('Coefficient $\beta_{i}$','Interpreter','latex')
saveas(fig1, strcat(output_file, output_title1), 'png');

output_title2 = 'beta_upperbar_lowerbar_second';
fig2 = figure;
plot(s,[c_range; Beta_all(:,1,2)],'Color',[0.2 0 0.8],'LineWidth',1.5)
hold on
plot(s,[c_range; Beta_all(:,2,2)],'Color',[0.2 0.4 0.8],'LineWidth',1.5)
hold on
plot(s,zero,':','Color',[0.7 0.7 0.7],'LineWidth',1.5)
title(['Equilibrium thresholds'],'Interpreter','latex')
ylim([-2 2])
dim1 = [0.25 0.5 0.9 0.3];
str1 = {'$m_{i}=1$'};
annotation('textbox',dim1,'String',str1,'FitBoxToText','on','interpreter','latex');
dim0 = [0.3 0.15 0.9 0.3];
str0 = {'$m_{i}=0$'};
annotation('textbox',dim0,'String',str0,'FitBoxToText','on','interpreter','latex');
dime = [0.7 0.4 0.9 0.3];
stre = {'$m_{i}=\emptyset$'};
annotation('textbox',dime,'String',stre,'FitBoxToText','on','interpreter','latex');
xlabel('Standard error $\sigma_{i}$','Interpreter','latex')
ylabel('Coefficient $\beta_{i}$','Interpreter','latex')
saveas(fig2, strcat(output_file, output_title2), 'png');