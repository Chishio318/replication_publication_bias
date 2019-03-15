clear all
%% environment
S=1;
s=1;
p=1;
bin=11;

N_range = 2;
c_range = linspace(0,0.4,bin);
s0_range = 1/3;
s00_range = 0;

%% supermajoritarian rule

% compute
[Beta_all, Computation_all]=threshold_compute(N_range, s, p, c_range, s0_range, s00_range);

N = 2;
super_welfare = zeros(1,bin);
for i=1:bin
    c=c_range(1,i);
    beta=Beta_all(:,:,2,i);
    [frequency, welfare_percent] = beta_welfare(beta, N, s, p, s0_range, s00_range, c, 1);
    super_welfare(1,i) = welfare_percent;
end


%% submajoritarian rule
% sim param
TolDiff = 0.001;
Change = 0.2; %not raise too high because start to oscillate
R = 5*10^5;
initial_seed = 1;
coeff_bar = 0.15;
coeff_under = -0.1;
sim_param = [TolDiff, Change, R, initial_seed, coeff_bar, coeff_under];

sub_welfare = zeros(1,bin);
for i=1:bin
    c=c_range(1,i);
    [beta, itr]=submajoritarian_threshold(N,c,s0_range,s00_range,s,p,sim_param,0);
    [frequency, welfare_percent] = beta_welfare(beta, N, s, p, s0_range, s00_range, c, 0);
    sub_welfare(1,i) = welfare_percent;
end

%% figure

output_file = '..\..\09_output\';
output_title = 'submajoritarian_welfare';

figure
plot(c_range,super_welfare,'Color',[0.2 0.4 0.8],'LineWidth',1.5)
hold on 
plot(c_range,sub_welfare,':','Color',[0.2 0.6 0.8],'LineWidth',1.5)
xlabel('$c$','Interpreter','latex', 'FontSize', 12)
ylabel('Welfare (relative to full information)','Interpreter','latex', 'FontSize', 12)
title(['Welfare under supermajoritarian and submajoritarian rules'],'Interpreter','latex', 'FontSize', 12)
h = legend('Supermajoritarian: $a^{\ast}=1\Leftrightarrow n_{1}>n_{0}$','Submajoritarian: $a^{\ast}=1\Leftrightarrow n_{1}\geq n_{0}$',...
                  'Location', 'southwest');
set(h,'Interpreter','latex', 'FontSize', 10)
saveas(fig, strcat(output_file, output_title), 'png');