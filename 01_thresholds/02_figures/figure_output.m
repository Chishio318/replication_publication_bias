function figure_output(Beta_all, s, output_folder, output_title, order, s0, s00)

fig = figure;
fig.PaperPositionMode = 'auto';
plot(s,Beta_all(:,1,1),'--','Color',[0.2 0 0.8],'LineWidth',1.5)
hold on
plot(s,Beta_all(:,1,2),'Color',[0.2 0 0.8],'LineWidth',1.5)
hold on
plot(s,Beta_all(:,1,3),'Color',[0.2 0.4 0.8],'LineWidth',1.5)
hold on
plot(s,Beta_all(:,1,4),'Color',[0.2 0.6 0.8],'LineWidth',1.5)
hold on
plot(s,Beta_all(:,2,2),'Color',[0.2 0 0.8],'LineWidth',1.5)
hold on
plot(s,Beta_all(:,2,3),'Color',[0.2 0.4 0.8],'LineWidth',1.5)
hold on
plot(s,Beta_all(:,2,4),'Color',[0.2 0.6 0.8],'LineWidth',1.5)
title(['(' order ') $\sigma_{b}$= ' s0 ' and  $\sigma_{0}$= ' s00 ''],'Interpreter','latex', 'FontSize', 18)
xlabel('$\sigma_{i}$','Interpreter','latex', 'FontSize', 18)
ylabel('$\beta_{i}$','Interpreter','latex', 'FontSize', 18)
h = legend('N=1','N=2','N=3','N=4', ...
    'Location', 'southwest');
set(h,'Interpreter','latex', 'FontSize', 14)
ylim([-2.5 2.5])
saveas(fig,strcat(output_folder,output_title),'png');

end
