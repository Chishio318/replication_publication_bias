%stem estimates

beta_labor0 = 0.01052155;
se_labor0 = 0.06242619;


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
 
N_pos=sum(pos_neg);
beta_possig =zeros(1,N_pos);
se_possig =zeros(1,N_pos);

index = 1;
for i=1:N_sig
    if pos_neg(1,i)==1
       pos_CDF = normcdf(t_threshold*se_sig(i,1), beta_labor0, sqrt(se_labor0^2+se_sig(i,1)^2));
        se_density(1,i) = pos_CDF /(1-pos_CDF);
beta_possig(1,index) = beta_sig(i,1);
se_possig(1,index) = se_sig(i,1);
index = index + 1;
    elseif pos_neg(1,i)==0
        se_density(1,i) = 0;
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
insig_sample = (t_sample<t_threshold);
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
critical_beta = -0.0623;
critical0 = [semax, 0];
critical1 = [critical_beta, critical_beta];
 
% without legend

fig = figure;
fig.PaperPositionMode = 'auto';
scatter(se_possig,beta_possig,'fill','d','MarkerFaceColor',[0.2 0 0.8],'MarkerEdgeColor',[0.2 0 0.8]);
hold on
plot(se_grid,beta_grid_up, 'Color',[0.2 0.6 1],'LineWidth', 1.5);
plot(critical0, critical1, 'Color',[1 0.8 0.2],'LineWidth', 1.5,'LineStyle','--');
 
scatter(se_sample_insig(1,n_view0:n_view1),beta_sample_insig(1,n_view0:n_view1),'d','MarkerEdgeColor',[0.2 0.6 1])
scatter(se_insig,beta_insig,'fill','MarkerFaceColor',[1 0.3 0],'MarkerEdgeColor',[1 0.3 0])
xlim([0 semax])
 
xlabel('Standard error $\sigma_{i}$','Interpreter','latex')
 
ylabel('Coefficient $\beta_{i}$','Interpreter','latex')
% 
% h = legend('Observed statistically significant  estimates', '95 percent threshold', 'Predicted statistically insignificant estimates',...
%     'Observed statistically insignificant estimates',...
%     'Location', 'bestoutside');
% set(h,'Interpreter','latex');
saveas(fig,strcat(output_folder,'legend'),'png');
 
% with legend
fig = figure;
fig.PaperPositionMode = 'auto';
scatter(se_possig,beta_possig,'fill','d','MarkerFaceColor',[0.2 0 0.8],'MarkerEdgeColor',[0.2 0 0.8]);
hold on
plot(se_grid,beta_grid_up, 'Color',[0.2 0.6 1],'LineWidth', 1.5);
 
scatter(se_sample_insig(1,n_view0:n_view1),beta_sample_insig(1,n_view0:n_view1),'d','MarkerEdgeColor',[0.2 0.6 1])
scatter(se_insig,beta_insig,'fill','MarkerFaceColor',[1 0.3 0],'MarkerEdgeColor',[1 0.3 0])
plot(critical0, critical1, 'Color',[1 0.8 0.2],'LineWidth', 1.5,'LineStyle','--');
xlim([0 semax])
xlabel('Standard error $\sigma_{i}$','Interpreter','latex')
ylabel('Coefficient $\beta_{i}$','Interpreter','latex')
h = legend('Observed statistically significant positive estimates', '95 percent threshold for positive results', 'Predicted negative estimates',...
    'Observed negative estimates','$\beta^{\ast}=\arg\sup_{\beta}\left\{ \hat{H}_{0}\left(\beta\right)-\tilde{H}_{0}\left(\beta|\hat{b}_{0},\hat{\sigma}_{0}\right)\right\} $',...
    'Location', 'bestoutside');
set(h,'Interpreter','latex');
saveas(fig,strcat(output_folder,'legend'),'png');
 





