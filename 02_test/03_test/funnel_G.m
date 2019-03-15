%stem estimates

% updated for 2018
beta_labor0 = -0.002041018;
se_labor0 = 0.055413008;

stem_param = [-0.002041018,  0.022924886,  0.055413008,  6.000000000, 0.109859449];

t_threshold = 1.96;

output_folder = '\\bbking2\chishio\winprofile\mydocs\Nov2018KStest';

%load
% se_u = beta_u./t_u;
% data0 = [beta_u, se_u, conclusion];

% 2018 data
data0 = [partialr, se, classification];

%% 2. classify

include_sig_pos=1;

include_sig_neg=0;

include_insig=0;

include_null=0;

include_all=101;

include = [include_sig_pos, include_sig_neg, include_insig, include_null, include_all];

 

data = sortrows(data0, 2);

[se_sig, se_insig, se_null, beta_sig, beta_insig, beta_null, pos_neg] = classify(data,include,t_threshold);

 

%% 3. predicted insignificant results

 

% 1. compute CDF

N_sig=size(se_sig,1);

se_density = zeros(1,N_sig);

CDF = zeros(1,N_sig);

 

for i=1:N_sig

    pos_CDF = normcdf(t_threshold*se_sig(i,1), beta_labor0, sqrt(se_labor0^2+se_sig(i,1)^2));

    neg_CDF = normcdf(-t_threshold*se_sig(i,1), beta_labor0, sqrt(se_labor0^2+se_sig(i,1)^2));

    if pos_neg(1,i)==1

        se_density(1,i) = (pos_CDF-neg_CDF)/(1-pos_CDF);

    elseif pos_neg(1,i)==0

        se_density(1,i) = (pos_CDF-neg_CDF)/neg_CDF;

    end

    CDF(1,i)=sum(se_density);

end

CDF(1,:)=CDF(1,:)/CDF(1,N_sig);

 

% 2. inverse CDF method to sample

N_total = 1000;

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

 

% sample beta

b_sample = normrnd(beta_labor0, se_labor0, [1 N_total]);

epsilon_sample = normrnd(0, 1, [1 N_total]);

beta_sample = b_sample + se_sample.*epsilon_sample;

 

% 3. rejection sampling to drop significant results

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

 

N_grid = 50;

semax = 0.225;

% note that N_insig is around 100. Thus, all: insig = 10:9. Thus, for 31

% significant results, there were 31x9=279 insignificant results.

n_view0 = 200;

n_view1 = 479;

 

se_grid = linspace(0,semax,N_grid);

xaxis = zeros(1,N_grid);

beta_grid_up = se_grid*t_threshold;

beta_grid_down = -se_grid*t_threshold;

critical0 = [0.0799, 0.0799];

critical1 = [0.6, -0.6];

 

% legend

fig = figure;

fig.PaperPositionMode = 'auto';

scatter(se_sig,beta_sig,'fill','d','MarkerFaceColor',[0.2 0 0.8],'MarkerEdgeColor',[0.2 0 0.8]);

hold on

plot(se_grid,beta_grid_up, 'Color',[0.2 0.6 1],'LineWidth', 1.5);

scatter(se_sample_insig(1,n_view0:n_view1),beta_sample_insig(1,n_view0:n_view1),'d','MarkerEdgeColor',[0.2 0.6 1])
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

saveas(fig,strcat(output_folder,'legend'),'png');

 print(gcf,'foo.png','-dpng','-r300'); 

 
%%%%%%%%%%%%%
% create step-by-step graphs
% step 2
fig = figure;

fig.PaperPositionMode = 'auto';

scatter(se_sig,beta_sig,'fill','d','MarkerFaceColor',[0.2 0 0.8],'MarkerEdgeColor',[0.2 0 0.8]);

hold on

plot(se_grid,beta_grid_up, 'Color',[0.2 0.6 1],'LineWidth', 1.5);

scatter(se_sample_insig(1,n_view0:n_view1),beta_sample_insig(1,n_view0:n_view1),'d','MarkerEdgeColor',[0.2 0.6 1])

xlim([0 semax])

plot(se_grid,beta_grid_down, 'Color',[0.2 0.6 1],'LineWidth', 1.5);

xlabel('Standard error $\sigma_{i}$','Interpreter','latex')

ylabel('Coefficient $\beta_{i}$','Interpreter','latex')

h = legend('Observed statistically significant  estimates', '95 percent threshold', 'Predicted statistically insignificant estimates',...
    'Observed statistically insignificant estimates','$\sigma^{\ast}=\arg\sup_{\sigma}\left\{ \hat{G}_{\emptyset}\left(\sigma\right)-\tilde{G}_{\emptyset}\left(\sigma|\hat{b}_{0},\hat{\sigma}_{0}\right)\right\} $',...
    'Location', 'bestoutside');
set(h,'Interpreter','latex');

saveas(fig,strcat(output_folder,'legend'),'png');

 % step 1
fig = figure;

fig.PaperPositionMode = 'auto';

scatter(se_sig,beta_sig,'fill','d','MarkerFaceColor',[0.2 0 0.8],'MarkerEdgeColor',[0.2 0 0.8]);

hold on

plot(se_grid,beta_grid_up, 'Color',[0.2 0.6 1],'LineWidth', 1.5);

xlim([0 semax])

plot(se_grid,beta_grid_down, 'Color',[0.2 0.6 1],'LineWidth', 1.5);

xlabel('Standard error $\sigma_{i}$','Interpreter','latex')

ylabel('Coefficient $\beta_{i}$','Interpreter','latex')

h = legend('Observed statistically significant  estimates', '95 percent threshold', 'Predicted statistically insignificant estimates',...
    'Observed statistically insignificant estimates','$\sigma^{\ast}=\arg\sup_{\sigma}\left\{ \hat{G}_{\emptyset}\left(\sigma\right)-\tilde{G}_{\emptyset}\left(\sigma|\hat{b}_{0},\hat{\sigma}_{0}\right)\right\} $',...
    'Location', 'bestoutside');
set(h,'Interpreter','latex');

saveas(fig,strcat(output_folder,'legend'),'png');

 