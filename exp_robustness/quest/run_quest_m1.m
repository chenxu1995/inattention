close all
clear
clc

%% Simulation config               
N = 1000;                    
L_50 = 15;        
p = [0.2,0.1,0];   
ls={'NC','MC','FC'};

% Set model
F = @(L,L_50,p2)  (1-p2)*1./ ( 1 + exp(1.*0.5.*(L_50-L)));

% set stopping rule and criterion
stopRule='ntrials';
stopCriterion=50;

% create QUEST+ object
stimDomain = linspace(-10, 50, 61);
respDomain = [0 1];

fid = fopen(['opt_quest_m1.txt'],'w+');
fprintf(fid,'threshold\tN\tmethod\tlistener\ttype\t\n');
%% Allocate memory
thresholds = nan(N,3);
numpresentations = nan(N,3);


for ip=1:length(p)
    for in=1:N
    % set up parameter domain, and create questplus object
    paramDomain = {linspace(-10, 50, 61),0};
    % do the in-th MC simulation
    QP = QuestPlus(F, stimDomain, paramDomain, respDomain, stopRule,stopCriterion);
     % initialise (with default, uniform, prior)
    QP.initialise();
      % run
      startGuess_mean = QP.getParamEsts('mean');
      startGuess_mode = QP.getParamEsts('mode');        
 
    while ~QP.isFinished()
        targ = QP.getTargetStim();
        pC = F(targ,L_50,p(ip));
        anscorrect = rand()<pC;
        QP.update(targ, anscorrect);
    end
             
    % get final parameter estimates
    endGuess_mean = QP.getParamEsts('mean');
    endGuess_mode = QP.getParamEsts('mode');
      
      thresholds(in,ip) = endGuess_mean(1);
      numpresentations(in,ip) = stopCriterion;
      fprintf(fid,'%2.1f\t%2.0f\tQUEST\t%s\tL\t\n',endGuess_mean(1),stopCriterion,ls{ip});
      fprintf('.');
    end
    fprintf('\n');
end