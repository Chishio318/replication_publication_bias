p_avg = zeros(N_sim,1);
p_diff = zeros(N_sim-1,1);
p_avg(1,1) = p(1,1);
for i=1:N_sim-1
    p_avg(i+1,1)=sum(p(1:i+1,1))/(i+1);
    p_diff(i,1) = p_avg(i+1,1)-p_avg(i,1);
end
axis = linspace(1,N_sim,N_sim);
axis2 = linspace(1,N_sim-1,N_sim-1);

fig = figure;
fig.PaperPositionMode = 'auto';
subplot(2,1,1) 
plot(axis,p_avg)
xlabel('Simulation number','Interpreter','latex')
ylabel('Average pvalue','Interpreter','latex')

subplot(2,1,2) 
plot(axis2,p_diff)
xlabel('Simulation number','Interpreter','latex')
ylabel('Difference in average pvalue','Interpreter','latex')
saveas(fig,strcat(output_folder,output_title),'png');
