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
ratio=[0 0.1 0.2]; 
p=[0 1];
ls={'FC','MC','NC'};  

fid = fopen(['opt_mlp2.txt'],'w+');
%% Allocate memory
thresholds = nan(N,3);
numpresentations = nan(N,3);
presentstimulus = @(presentation,value) presentation;
for ir=1:length(ratio)
    for in=1:N
    gambling_array = randperm(minmeasures,round(minmeasures*ratio(ir)));
    virtualanswererm2([], [], [], L_50s,s_50s,p,gambling_array);
      % do the in-th MC simulation
      [threshold, values, reversals, measures, presentations, answers, adjustments] =...
        mlp(presentstimulus, @virtualanswererm2, target,minreversals, discardreversals, minmeasures, startvalue, offset,steps);
          thresholds(in,ir) = threshold;
          numpresentations(in,ir) = length(values);  
    fprintf(fid,'%2.1f\t%2.0f\tMLP\t%s\tS\t\n',threshold,length(values),ls{ir});
          fprintf('.');
    end
    fprintf('\n');
end