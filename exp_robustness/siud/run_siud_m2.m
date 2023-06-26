close all
clear
clc
%% Adaptation config -- same as for behavioural experiment can be adjusted here to optimize measurement procedure
startvalue = 40;
p=[0 1];

%% Simulation config               
N = 1000;                     % number of MC simulations, more is better but takes more time
L_50s = 15;         % thresholds at the turning point of the psychometric function, here that is at an overall detection rate of 75%
s_50s = 0.5;    
minmeasures = 1;
minreversals = 25;
discardreversals=1;
steps =[10 5 2];
ratio=[0 0.1 0.2]; 
minmeasure=50;
ls={'FC','MC','NC'};

fid = fopen(['opt_siud2.txt'],'w+');
%% Allocate memory
thresholds = nan(N,3);
numpresentations = nan(N,3);
presentstimulus = @(presentation,value) presentation;

for ir=1:length(ratio)
    for in=1:N
    % generate gambling array
    gambling_array = randperm(minmeasure,round(minmeasure*ratio(ir)));
    virtualanswerersiudm2([], [], [],[], L_50s,s_50s,p,gambling_array);
      [threshold, values, reversals, measures, presentations, answers, adjustments] =...
        siud(presentstimulus, @virtualanswerersiudm2, minreversals, discardreversals, minmeasures, startvalue, steps);
      thresholds(in,ir) = threshold;
       numpresentations(in,ir) = length(values);
       fprintf(fid,'%2.1f\t%2.0f\tSIUD\t%s\tS\t\n',threshold,length(values),ls{ir});
      fprintf('.');
    end
      fprintf('\n');
end