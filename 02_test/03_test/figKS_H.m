function [KS_overall, KS_argparam, avg_p, avg_criticalKS] = figKS_H(N_simnull, stem_param, param_sim, beta_insig, se_insig, N_bin, t_threshold, buffer, empcount, output_folder, output_title)

%% CDF
beta_min = min(beta_insig) - buffer(1,1);
beta_max = max(beta_insig) + buffer(1,2);
beta_range = linspace(beta_min,beta_max, N_bin);
cdf_H

diff = empcount*(cdf_empirical - cdf_counterfactual(1,:));
[sup_diff, sup_ind] = max(diff);

cdf_95ci = zeros(2,N_bin);
up_95ci = 0.025;
low_95ci = 0.975;
for i=1:N_bin
    cdf_distribution0 = cdf_counterfactual(2:N_sim+1,i);
    cdf_distribution = sortrows(cdf_distribution0);
    cdf_95ci(1,i) = cdf_distribution(floor(up_95ci*N_sim),1);
    cdf_95ci(2,i) = cdf_distribution(ceil(low_95ci*N_sim),1);
    %to ensure integer, use floor and ceiling (conservative rounding)
end

%% figure
beta_range2 = [beta_range fliplr(beta_range)];
CDF_95 = [cdf_95ci(1,:) fliplr(cdf_95ci(2,:))];
%figure
fig = figure;
fig.PaperPositionMode = 'auto';
CDF_emp = stairs(beta_range, cdf_empirical);
hold on;
CDF_ctf= stairs(beta_range, cdf_counterfactual(1,:));
fill95 = fill(beta_range2,CDF_95,[0,0.2,0.8]);
KS = line([beta_range(1,sup_ind) beta_range(1,sup_ind)],[cdf_counterfactual(1,sup_ind) cdf_empirical(1,sup_ind)]);
set(CDF_emp,'Color',[0,0.8,0.2])
set(CDF_emp,'LineWidth', 1.5 )
set(CDF_ctf,'Color',[0,0.2,0.8])
set(CDF_ctf,'LineWidth', 1.5 )
set(CDF_ctf,'LineStyle', '-.')
set(KS,'Color',[0.8 0.1 0.1])
set(KS,'LineWidth', 2)
set(fill95,'EdgeColor','None')
set(fill95,'facealpha',.4)
title(['Distribution of Coefficients of Negative Results' ],'Interpreter','latex')
xlabel('$\beta$','Interpreter','latex')
ylabel('$H_{0}$','Interpreter','latex')
h = legend('Observed distribution $\hat{H_{0}}$', ...
    'Predicted distribution $\tilde{H_{0}}$',...
    'Bootstrap 95 CI of $\tilde{H_{0}}$','Kolmogorov-Smirnov statistics',...
    'Location', 'southeast');
set(h,'Interpreter','latex')
xlim([beta_range(1,1) beta_range(1,N_bin)])
ylim([0 1])
saveas(fig,strcat(output_folder,output_title),'png');

end