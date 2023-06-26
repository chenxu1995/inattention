close all
clear
clc

%% Adaptation config
maxTrials=30;
firstLevelDBHL=-10;
repeatLevelDBHL=5;
startLevelDBHL=-10;
discardreversals=0;

%% Simulation config
L_50s = 15;         % thresholds at the turning point of the psychometric function, here that is at an overall detection rate of 75%
s_50s = 0.5;          % slopes, change dependent on the task
N = 1000;                     % number of MC simulations, more is better but takes more time
p = [0 1];
maxLevelDev = 3;
minTrials = 7;
dBstep=2;
minmeasures=50;
ratio=[0 0.1 0.2]; 
ls={'FC','MC','NC'};
discardreversals=0;

fid = fopen(['opt_apta2.txt'],'w+');
%% Allocate memory
thresholds = nan(N,3);
numpresentations = nan(N,3);
presentstimulus = @(presentation,value) presentation;

%% run mc simulation
for ir=1:length(ratio)
    % this uses a persistent variable to store the configuration
    presentstimulus = @(presentation,value) presentation;
    for in=1:N
    gambling_array = randperm(minmeasures,round(minmeasures*ratio(ir)));
    virtualanswererm2([], [], [], L_50s,s_50s,p,gambling_array);
      % do the in-th MC simulation
      [threshold, values, reversals, measures, presentations, answers, adjustments]=apta(presentstimulus, @virtualanswererm2,discardreversals,firstLevelDBHL,maxTrials,minTrials,repeatLevelDBHL,startLevelDBHL,dBstep,maxLevelDev);
      thresholds(in,ir) = threshold;
       numpresentations(in,ir) = length(values);
       fprintf(fid,'%2.1f\t%2.0f\tAPTA\t%s\tS\t\n',threshold,length(values),ls{ir});
      fprintf('.');
    end
      fprintf('\n');
end

