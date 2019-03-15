function funnelplot_G(critical_se, seed_num, stem_param, beta_sig, se_sig, beta_null, se_null, pos_neg, t_threshold, output_folder, output_title, figure_option)

N_total = 1000; %choose some sufficiently large number
rng(seed_num)
beta0 = stem_param(1,1);
se0 = stem_param(1,3);
N_grid = 50;
semax = 0.225;

%% 1. estimate CDF
N_sig=size(se_sig,1);
se_density = zeros(1,N_sig);
CDF = zeros(1,N_sig);

for i=1:N_sig
    pos_CDF = normcdf(t_threshold*se_sig(i,1), beta0, sqrt(se0^2+se_sig(i,1)^2));
    neg_CDF = normcdf(-t_threshold*se_sig(i,1), beta0, sqrt(se0^2+se_sig(i,1)^2));

    if pos_neg(1,i)==1
        se_density(1,i) = (pos_CDF-neg_CDF)/(1-pos_CDF);

    elseif pos_neg(1,i)==0
        se_density(1,i) = (pos_CDF-neg_CDF)/neg_CDF;
    end

    CDF(1,i)=sum(se_density);
end
CDF(1,:)=CDF(1,:)/CDF(1,N_sig);

%% 2. sample sigmas by inverse CDF method
unirand = rand(N_total,1);
lessthan = zeros(N_total, N_sig);
for i=1:N_total
    lessthan(i,:) = (unirand(i,1)>CDF);
end
se_index  = sum(lessthan, 2)'+1;

se_sample= zeros(1, N_total);
for i=1:N_total
    se_sample(1,i) = se_sig(se_index(1,i),1);
end

%% 3. sample betas by rejection sampling

b_sample = normrnd(beta0, se0, [1 N_total]);
epsilon_sample = normrnd(0, 1, [1 N_total]);
beta_sample = b_sample + se_sample.*epsilon_sample;

% rejection sampling to drop significant results
t_sample = beta_sample./se_sample;
insig_sample = (abs(t_sample)<t_threshold);
N_insig = sum(insig_sample);
beta_sample_insig = zeros(1,N_insig);
se_sample_insig = zeros(1,N_insig);

index = 1;
for i=1:N_total
    if insig_sample(1,i)==1
        beta_sample_insig(1,index)=beta_sample(1,i);
        se_sample_insig(1,index)=se_sample(1,i);
        index = index + 1;
    end
end

%% 4. plot figures
n_view = floor(N_insig/(N_total - N_insig))*N_sig; %number of insignificant studies to be shown

se_grid = linspace(0,semax,N_grid);
xaxis = zeros(1,N_grid);
beta_grid_up = se_grid*t_threshold;
beta_grid_down = -se_grid*t_threshold;
critical0 = [critical_se, critical_se];
critical1 = [0.6, -0.6];
fig.PaperUnits = 'inches';

if figure_option == 0
    
    fig = figure;
    fig.PaperPositionMode = 'auto';
    scatter(se_sig,beta_sig,'fill','d','MarkerFaceColor',[0.2 0 0.8],'MarkerEdgeColor',[0.2 0 0.8]);
    
    hold on
    plot(se_grid,beta_grid_up, 'Color',[0.2 0.6 1],'LineWidth', 1.5);
    scatter(se_sample_insig(1,1:n_view),beta_sample_insig(1,1:n_view),'d','MarkerEdgeColor',[0.2 0.6 1])
    scatter(se_null,beta_null,'fill','MarkerFaceColor',[1 0.3 0],'MarkerEdgeColor',[1 0.3 0])
    
    plot(critical0, critical1, 'Color',[1 0.8 0.2],'LineWidth', 1.5,'LineStyle','--');
    xlim([0 semax])
    plot(se_grid,beta_grid_down, 'Color',[0.2 0.6 1],'LineWidth', 1.5);
    xlabel('Standard error $\sigma_{i}$','Interpreter','latex')
    ylabel('Coefficient $\beta_{i}$','Interpreter','latex')
    h = legend('Observed statistically significant  estimates', '95 percent threshold', 'Predicted statistically insignificant estimates',...
        'Observed statistically insignificant estimates','$\sigma^{\ast}=\arg\sup_{\sigma}\left\{ \hat{G}_{\emptyset}\left(\sigma\right)-\tilde{G}_{\emptyset}\left(\sigma|\hat{b}_{0},\hat{\sigma}_{0}\right)\right\} $',...
        'Location', 'bestoutside');
    set(h,'Interpreter','latex');
    fig.PaperPosition = [0 0 7 3];
    saveas(fig,strcat(output_folder,output_title),'png');
    
elseif figure_option == 1
    
    fig = figure;
    fig.PaperPositionMode = 'auto';
    scatter(se_sig,beta_sig,'fill','d','MarkerFaceColor',[0.2 0 0.8],'MarkerEdgeColor',[0.2 0 0.8]);
    hold on
    plot(se_grid,beta_grid_up, 'Color',[0.2 0.6 1],'LineWidth', 1.5);
    plot(se_grid,beta_grid_down, 'Color',[0.2 0.6 1],'LineWidth', 1.5);
       
    xlim([0 semax])

    xlabel('Standard error $\sigma_{i}$','Interpreter','latex')
    ylabel('Coefficient $\beta_{i}$','Interpreter','latex')
    h = legend('Observed statistically significant  estimates', '95 percent threshold', 'Predicted statistically insignificant estimates',...
        'Observed statistically insignificant estimates','$\sigma^{\ast}=\arg\sup_{\sigma}\left\{ \hat{G}_{\emptyset}\left(\sigma\right)-\tilde{G}_{\emptyset}\left(\sigma|\hat{b}_{0},\hat{\sigma}_{0}\right)\right\} $',...
        'Location', 'bestoutside');
    set(h,'Interpreter','latex');
    fig.PaperPosition = [0 0 7 3];
    saveas(fig,strcat(output_folder,output_title),'png');
    
elseif figure_option == 2
    
    fig = figure;
    fig.PaperPositionMode = 'auto';
    scatter(se_sig,beta_sig,'fill','d','MarkerFaceColor',[0.2 0 0.8],'MarkerEdgeColor',[0.2 0 0.8]);
    
    hold on
    plot(se_grid,beta_grid_up, 'Color',[0.2 0.6 1],'LineWidth', 1.5);
    plot(se_grid,beta_grid_down, 'Color',[0.2 0.6 1],'LineWidth', 1.5);
    scatter(se_sample_insig(1,1:n_view),beta_sample_insig(1,1:n_view),'d','MarkerEdgeColor',[0.2 0.6 1])
    
    xlim([0 semax])

    xlabel('Standard error $\sigma_{i}$','Interpreter','latex')
    ylabel('Coefficient $\beta_{i}$','Interpreter','latex')
    h = legend('Observed statistically significant  estimates', '95 percent threshold', 'Predicted statistically insignificant estimates',...
        'Observed statistically insignificant estimates','$\sigma^{\ast}=\arg\sup_{\sigma}\left\{ \hat{G}_{\emptyset}\left(\sigma\right)-\tilde{G}_{\emptyset}\left(\sigma|\hat{b}_{0},\hat{\sigma}_{0}\right)\right\} $',...
        'Location', 'bestoutside');
    set(h,'Interpreter','latex');
    fig.PaperPosition = [0 0 7 3];
    saveas(fig,strcat(output_folder,output_title),'png');
    
end

end
