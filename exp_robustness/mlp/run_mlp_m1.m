close all
clear
clc
%% Adaptation config -- same as for behavioural experiment can be adjusted here to optimize measurement procedure
discardreversals = 0;
target=0.6310;
startvalue=-60;
offset=100; 
minreversals = 1;

%% Simulation config
L_50s = 15;         % thresholds at the turning point of the psychometric function, here that is at an overall detection rate of 75%
s_50s = 0.5;    
N = 1000;                     % number of MC simulations, more is better but takes more time
minmeasures = 50;
steps=1;
p = {[0 0.8],[0 0.9],[0 1]};   
ls={'NC','MC','FC'};

fid = fopen(['opt_mlp.txt'],'w+');
fprintf(fid,'threshold\tN\tmethod\tlistener\ttype\t\n');
%% Allocate memory
thresholds = nan(N,3);
numpresentations = nan(N,3);
presentstimulus = @(presentation,value) presentation;
for ip=1:length(p)
    virtualanswerer([], [], [],L_50s,s_50s,p{ip});
    for in=1:N
      % do the in-th MC simulation
      [threshold, values, reversals, measures, presentations, answers, adjustments] =...
        mlp(presentstimulus, @virtualanswerer, target,minreversals, discardreversals, minmeasures, startvalue, offset,steps);
          thresholds(in,ip) = threshold;
      numpresentations(in,ip) = length(values);  
    fprintf(fid,'%2.1f\t%2.0f\tMLP\t%s\tL\t\n',threshold,length(values),ls{ip});
      fprintf('.');
    end
    fprintf('\n');
end