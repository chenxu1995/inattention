%This is implementation for Monte-carlo simulation (siam[1] method)
%[1] Kaernbach, Christian. "A single‐interval adjustment‐matrix (SIAM) procedure for unbiased adaptive testing." The Journal of the Acoustical Society of America 88.6 (1990): 2645-2655.
%Author: chen.xu@uol.de
%close all
%clear
%clc

%% Adaptation config -- same as for behavioural experiment can be adjusted here to optimize measurement procedure
target = 0.75; % 87.5%, i.e., the equivalent to a 75% point on a psychometric function between 0 and 100%
startvalue = 20;
feedback = 0;

%% Simulation config
L_50s = 10;         % thresholds at the turning point of the psychometric function, here that is at an overall detection rate of 75%
s_50s = 0.5;         % slopes, change dependent on the task                
N = 1000;            % number of MC simulations, more is better but takes more time
minmeasures = 30;
minreversals = 18;
discardreversals=2;
steps =[2 2 1 1];
p = {[0.5 0.8],[0.5 0.9],[0.5 1]};   

%% Allocate memory
value={N,length(p)};
    % this uses a persistent variable to store the configuration
presentstimulus = @(presentation,value) presentation;
for ip=1:length(p)
 virtualanswerer([], [], [],L_50s,s_50s,p{ip});
    for in=1:N
      % do the in-th MC simulation
      [threshold, values, reversals, measures, presentations, answers, adjustments] =...
        siam(presentstimulus, @virtualanswerer, target, minreversals, discardreversals, minmeasures, startvalue, steps, feedback);
      value{in,ip} =values;
      fprintf('.');
    end
      fprintf('\n');
end

