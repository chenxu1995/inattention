%This is implementation for Monte-carlo simulation (siam[1] method)
%[1] Kaernbach, Christian. "A single‐interval adjustment‐matrix (SIAM) procedure for unbiased adaptive testing." The Journal of the Acoustical Society of America 88.6 (1990): 2645-2655.
%Author: chen.xu@uol.de
close all
clear
clc

%% Adaptation config -- same as for behavioural experiment can be adjusted here to optimize measurement procedure
target = 0.75; % 87.5%, i.e., the equivalent to a 75% point on a psychometric function between 0 and 100%
startvalue = 40;
feedback = 0;

%% Simulation config
L_50s = 15;         % thresholds at the turning point of the psychometric function, here that is at an overall detection rate of 75%
s_50s = 0.5;         % slopes, change dependent on the task                
N = 1000;            % number of MC simulations, more is better but takes more time
p= [0.5 1];
minmeasures = 1;
minreversals = 10;
discardreversals=1;
steps =[4 4 2 1];
ratio=[0 0.1 0.2]; 
minmeasure=50;
ls={'FC','MC','NC'};

fid = fopen(['opt_siam2.txt'],'w+');
%% Allocate memory
thresholds = nan(N,3);
numpresentations = nan(N,3);
presentstimulus = @(presentation,value) presentation;

for ir=1:length(ratio)
    % this uses a persistent variable to store the configuration
    presentstimulus = @(presentation,value) presentation;
    for in=1:N
    % generate gambling array
    gambling_array = randperm(minmeasure,round(minmeasure*ratio(ir)));
    virtualanswererm2([], [], [], L_50s,s_50s,p,gambling_array);
      % do the in-th MC simulation
      [threshold, values, reversals, measures, presentations, answers, adjustments] =...
        siam(presentstimulus, @virtualanswererm2, target, minreversals, discardreversals, minmeasures, startvalue, steps, feedback);
      thresholds(in,ir) = threshold;
       numpresentations(in,ir) = length(values);
       fprintf(fid,'%2.1f\t%2.0f\tSIAM\t%s\tS\t\n',threshold,length(values),ls{ir});
      fprintf('.');
    end
      fprintf('\n');
end