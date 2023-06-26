addpath('matlab_fig')
% Load saved figures and disable plotting then enable plotting
set(groot,'defaultFigureVisible','off');
c=hgload('mlp.fig');
k=hgload('apta.fig');
s=hgload('siam.fig');
d=hgload('siud.fig');
b=hgload('quest.fig');
a=hgload('grabr.fig');
e=hgload('uml.fig');
set(groot,'defaultFigureVisible','on');
% Prepare subplots
set(0,'DefaultLineLineWidth',2);
%set(0,'DefaultLinefontsize',18);
fig = figure;
h(1)=subplot(2,4,1);
title('(A) SIUD', 'FontSize', 18);
h(2)=subplot(2,4,2);
title('(B) GRaBr', 'FontSize', 18);
h(3)=subplot(2,4,3);
title('(C) APTA', 'FontSize', 18);
h(4)=subplot(2,4,4);
title('(D) QUEST+', 'FontSize', 18);
h(5)=subplot(2,4,5);
title('(E) MLP', 'FontSize',18);
h(6)=subplot(2,4,6);
title('(F) UML', 'FontSize', 18);
h(7)=subplot(2,4,7);
title('(G) SIAM', 'FontSize', 18);

h(2).Position = h(2).Position + [-0.025 0 0 0];
h(3).Position = h(3).Position + [-0.045 0 0 0];
h(4).Position = h(4).Position + [-0.065 0 0 0];
h(5).Position = h(5).Position + [0 0.08 0 0];
h(6).Position = h(6).Position + [-0.025 0.08 0 0];
h(7).Position = h(7).Position + [-0.045 0.08 0 0];

% Paste figures on the subplots
copyobj(allchild(get(d,'CurrentAxes')),h(1));
copyobj(allchild(get(a,'CurrentAxes')),h(2));
copyobj(allchild(get(k,'CurrentAxes')),h(3));
copyobj(allchild(get(b,'CurrentAxes')),h(4));
copyobj(allchild(get(c,'CurrentAxes')),h(5));
copyobj(allchild(get(e,'CurrentAxes')),h(6));
copyobj(allchild(get(s,'CurrentAxes')),h(7));

% set same xlim for all subplots
linkaxes([h(1) h(2) h(3) h(4) h(5) h(6) h(7)],'x');
h(1).XLim = [0 50];



% adjust xlabel, and ylabel
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
label_y=ylabel(han,'Tone level (dB)','FontSize',18);
label_y.Position(2) = label_y.Position(2)+0.1; 
label_y.Position(1) = label_y.Position(1)+0.05; 
label_x=xlabel(han,'Trial number N','FontSize',18); 
label_x.Position(1) = label_x.Position(1); 
label_x.Position(2) = label_x.Position(2)+0.13; 


hold on
legend('','Position',[0.7 0.3 0.1 0.1]);
plot([NaN NaN], [NaN NaN] ,'-.','LineWidth',2,'color','k', 'DisplayName',"Target threshold: 15 dB");
plot([NaN NaN], [NaN NaN] ,'Color',[0 1 0].*0.8,'LineWidth',2, 'DisplayName',"Estimated threshold");
hold off

%exportgraphics(fig,'example_run.tiff','Resolution',300);
