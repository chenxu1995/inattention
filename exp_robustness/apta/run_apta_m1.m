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
maxLevelDev = 3;
minTrials =7;
dBstep=2;
p = {[0 0.8],[0 0.9],[0 1]};   
ls={'NC','MC','FC'};
fid = fopen(['opt_apta.txt'],'w+');
fprintf(fid,'threshold\tN\tmethod\tlistener\ttype\t\n');

%% Allocate memory
thresholds = nan(N,3);
numpresentations = nan(N,3);
presentstimulus = @(presentation,value) presentation;
    % this uses a persistent variable to store the configuration
    presentstimulus = @(presentation,value) presentation;
    for ip=1:length(p)
    virtualanswerer([], [], [],L_50s,s_50s,p{ip}); 
    for in=1:N
      % do the in-th MC simulation
      [threshold, values, reversals, measures, presentations, answers, adjustments]=apta(presentstimulus, @virtualanswerer,discardreversals,firstLevelDBHL,maxTrials,minTrials,repeatLevelDBHL,startLevelDBHL,dBstep,maxLevelDev);
      thresholds(in,ip) = threshold;
      numpresentations(in,ip) = length(values);
      fprintf(fid,'%2.1f\t%2.0f\tAPTA\t%s\tL\t\n',threshold,length(values),ls{ip});
      fprintf('.');
    end
      fprintf('\n');
    end
