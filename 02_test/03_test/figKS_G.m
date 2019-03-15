function figKS_G(N_simnull, stem_param, param_sim, se_sig, se_null, pos_neg, N_bin, t_threshold, buffer, empcount, output_folder, output_title)


%% CDF
density_G
se_min=min(se_sig(1,1), se_null(1,1))-buffer(1,1);
se_max =min(se_sig(N_sig,1),se_null(N_null,1))+buffer(1,2);
cdf_G

cdf_diff = empcount*(cdf_empirical(1,:)-cdf_counterfactual(1,:));
[sup_diff, sup_ind] = max(cdf_diff);

%% 95CI
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
se_range2 = [se_range fliplr(se_range)];
CDF_95 = [cdf_95ci(1,:) fliplr(cdf_95ci(2,:))];

fig = figure;
fig.PaperPositionMode = 'auto';
CDF_emp = stairs(se_range, cdf_empirical);
hold on;
CDF_ctf= stairs(se_range, cdf_counterfactual(1,:));
fill95 = fill(se_range2,CDF_95,[0,0.2,0.8]);
KS = line([se_range(1,sup_ind) se_range(1,sup_ind)],[cdf_counterfactual(1,sup_ind) cdf_empirical(1,sup_ind)]);
set(CDF_emp,'Color',[0,0.8,0.2])
set(CDF_emp,'LineWidth', 1.5 )
set(CDF_ctf,'Color',[0,0.2,0.8])
set(CDF_ctf,'LineWidth', 1.5 )
set(CDF_ctf,'LineStyle', '-.')
set(KS,'Color',[0.8 0.1 0.1])
set(KS,'LineWidth', 2)
set(fill95,'EdgeColor','None')
set(fill95,'facealpha',.4)
title(['Distribution of Standard Errors of Null Results' ],'Interpreter','latex')
xlabel('$\sigma$','Interpreter','latex')
ylabel('$G_{\emptyset}$','Interpreter','latex')
h = legend('Observed distribution $\hat{G_{\emptyset}}$', ...
    'Predicted distribution $\tilde{G_{\emptyset}}$',...
    'Bootstrap 95 CI of $\tilde{G_{\emptyset}}$','Kolmogorov-Smirnov statistics',...
    'Location', 'southeast');
set(h,'Interpreter','latex')
xlim([se_range(1,1) se_range(1,N_bin)])
ylim([0 1])
saveas(fig,strcat(output_folder,output_title),'png');

end
