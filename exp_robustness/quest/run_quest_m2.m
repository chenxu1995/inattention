close all
clear
clc

%% Simulation config               
N = 1000;                    
L_50 = 15;        
ratio = [0.2,0.1,0]; 
p2=0;
ls={'NC','MC','FC'};

% Set model
F = @(L,L_50,p2)  (1-p2)*1./ ( 1 + exp(1.*0.5.*(L_50-L)));

% set stopping rule and criterion
stopRule='ntrials';
stopCriterion=50;

% create QUEST+ object
stimDomain = linspace(-10, 50, 61);
respDomain = [0 1];

fid = fopen(['opt_quest_m2.txt'],'w+');
fprintf(fid,'threshold\tN\tmethod\tlistener\ttype\t\n');
%% Allocate memory
thresholds = nan(N,3);
numpresentations = nan(N,3);


for ir=1:length(ratio)
    for in=1:N
    % set up parameter domain, and create questplus object
    paramDomain = {linspace(-10, 50,61),p2};
    % do the in-th MC simulation
    QP = QuestPlus(F, stimDomain, paramDomain, respDomain, stopRule,stopCriterion);
     % initialise (with default, uniform, prior)
    QP.initialise();
      % run
      startGuess_mean = QP.getParamEsts('mean');
      startGuess_mode = QP.getParamEsts('mode');        

    count = 1;
    gambling_array = randperm(stopCriterion,round(stopCriterion*ratio(ir)));
    while ~QP.isFinished()
        targ = QP.getTargetStim();
        pC = F(targ,L_50,p2);  
        anscorrect = rand()<pC;
       if ismember(count,gambling_array)
         anscorrect =round(rand);
       end
        QP.update(targ, anscorrect);
        count = count +1;
    end
             
    % get final parameter estimates
    endGuess_mean = QP.getParamEsts('mean');
    endGuess_mode = QP.getParamEsts('mode');
      
      thresholds(in,ir) = endGuess_mean(1);
      numpresentations(in,ir) = stopCriterion;
      fprintf(fid,'%2.1f\t%2.0f\tQUEST\t%s\tS\t\n',endGuess_mean(1),stopCriterion,ls{ir});
      fprintf('.');
    end
    fprintf('\n');
end