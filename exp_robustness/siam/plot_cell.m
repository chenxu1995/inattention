nc=value(:,1);
mc=value(:,2);
fc=value(:,3);
M_nc = max(cellfun(@length, nc));
for i=1:numel(nc)
 nc{i}(end:M_nc)=NaN;
end

M_mc = max(cellfun(@length, mc));
for i=1:numel(mc)
 mc{i}(end:M_mc)=NaN;
end

M_fc = max(cellfun(@length, fc));
for i=1:numel(fc)
 fc{i}(end:M_fc)=NaN;
end

p_nc=cell2mat(nc);
p_mc=cell2mat(mc);
p_fc=cell2mat(fc);

clf
s =shadedErrorBar([],mean(p_nc,1),std(p_nc), 'lineprops', 'r-');
hold on
s1=shadedErrorBar([],mean(p_mc,1),std(p_mc), 'lineprops', 'y-');
s2=shadedErrorBar([],mean(p_fc,1),std(p_fc), 'lineprops', 'b-');

xlim([0 45])

% Set face and edge properties
s.mainLine.LineWidth = 2;
s1.mainLine.LineWidth = 2;
s2.mainLine.LineWidth = 2;
grid on
