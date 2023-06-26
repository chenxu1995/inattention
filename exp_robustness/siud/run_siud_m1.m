close all
clear
clc
%% Adaptation config -- same as for behavioural experiment can be adjusted here to optimize measurement procedure
startvalue = 40;

%% Simulation config               
N = 1000;                     % number of MC simulations, more is better but takes more time
L_50s = 15;         % thresholds at the turning point of the psychometric function, here that is at an overall detection rate of 75%
s_50s = 0.5;    
minmeasures = 1;
minreversals = 25;
discardreversals=1;
steps =[10 5 2];
p = {[0 0.8],[0 0.9],[0 1]};   
ls={'NC','MC','FC'};

fid = fopen(['opt_siud.txt'],'w+');
fprintf(fid,'threshold\tN\tmethod\tlistener\ttype\t\n');
%% Allocate memory
thresholds = nan(N,3);
numpresentations = nan(N,3);
presentstimulus = @(presentation,value) presentation;
for ip=1:length(p)
    virtualanswerersiud([], [], [],L_50s,s_50s,p{ip});
    for in=1:N
      % do the in-th MC simulation
      [threshold, values, reversals, measures, presentations, answers, adjustments] =...
        siud(presentstimulus, @virtualanswerersiud, minreversals, discardreversals, minmeasures, startvalue, steps);
      thresholds(in,ip) = threshold;
      numpresentations(in,ip) = length(values);
      fprintf(fid,'%2.1f\t%2.0f\tSIUD\t%s\tL\t\n',threshold,length(values),ls{ip});
      fprintf('.');
    end
      fprintf('\n');
      end
