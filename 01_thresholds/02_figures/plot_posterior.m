%run with Beta_all for N=2,...,10 first

Nm1 = N -1;

posterior = zeros(N+1,N+1,Nm1);
for i=1:Nm1
    i1 = i+1;
    i2 = i+2;
    [count, post] = beta_posterior(Beta_all(:,:,i1), i1, s, p, s0, s00, c);
    posterior(1:i2, 1:i2, i) = post;
end


num_store = zeros(2,Nm1);
% col1 when n0=n1
% col2 when n0<n1
for i=1:Nm1
    i1 = i+1;
    num_store(1,i) = floor(i1/2)+1;
    num_store(2,i) = ceil(i1/2);
end

N0 = sum(num_store(1,:),2);
N1 = sum(num_store(2,:),2);
posterior_store0 = zeros(N0,2);
posterior_store1 = zeros(N1,2);

index0 = 1;
index1 = 1;
for i=1:Nm1
    n0 = num_store(1,i);
    n1 = num_store(2,i);
    
    for j0=1:n0
        posterior_store0(index0,2)=posterior(j0,j0,i);
        posterior_store0(index0,1)=i+1;
        index0 = index0 + 1;
    end
   
    for j1=1:n1
        posterior_store1(index1,2)=posterior(j1,j1+1,i);
        posterior_store1(index1,1)=i+1;
        index1 = index1 + 1;
    end 
end

xaxis = linspace(1,N,N);
yplot = zeros(1,N);
%posterior already adjusted
output_folder = 'C:\Users\Chishio\Documents\01_Research\03_Publication Bias\06_Code online\Appendix C\01_Ouput\';
output_title = 'posterior';


fig = figure;
scatter(posterior_store1(:,1),posterior_store1(:,2), size, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5)
hold on
scatter(posterior_store0(:,1),posterior_store0(:,2), size, 'd', 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[1 1 1], 'LineWidth',1.5)
hold on
plot(xaxis, yplot,'Color',[0.7 0.7 0.7],'LineWidth',1.5)
xlabel('Number of researchers $N$','Interpreter','latex', 'FontSize', 12)
ylabel('Posteriors $\bf{E}$ $b\left(n\right)$','Interpreter','latex', 'FontSize', 12)
title(['Distribtion of posterior benefit of policy given reports'],'Interpreter','latex', 'FontSize', 12)
h = legend('$n_{1}=n_{0}+1$','$n_{1}=n_{0}$', ...
    'Location', 'southeast');
set(h,'Interpreter','latex', 'FontSize', 12)
ylim([-0.08 0.08])
saveas(fig,strcat(output_folder,output_title),'png');
