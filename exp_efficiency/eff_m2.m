%% SIUD
close all
clear
clc
startvalue = 40;
p=[0 1];    
N = 5000;                     % number of MC simulations, more is better but takes more time
L_50s = 15;         % thresholds at the turning point of the psychometric function, here that is at an overall detection rate of 75%
s_50s = 0.5;    
minmeasures = 1;
minreversals =[2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40];
discardreversals=1;
steps =[10 5 2];
ratio=[0 0.1 0.2]; 
ls={'FC','MC','NC'};

thresholds = nan(numel(minreversals),numel(ratio),N);
numpresentations = zeros(numel(minreversals),numel(ratio),N);
presentstimulus = @(presentation,value) presentation;
for ir=1:1:length(minreversals)
    for ira=1:length(ratio)
    for in=1:N
    % generate gambling array
    gambling_array = randperm(minreversals(ir)*2,round(minreversals(ir)*ratio(ira)*2));
    virtualanswerersiudm2([], [], [],[], L_50s,s_50s,p,gambling_array);
      [threshold, values, reversals, measures, presentations, answers, adjustments] =...
        siud(presentstimulus, @virtualanswerersiudm2, minreversals(ir), discardreversals, minmeasures, startvalue, steps);
      numpresentations(ir,ira,in) = length(values);
      thresholds(ir,ira,in) = threshold;
      fprintf('.');
    end
      fprintf('\n');
    end
end

means = mean(thresholds,3,'omitnan');
stds = std(thresholds,[],3,'omitnan'); 
avgnumpresentations = mean(numpresentations,3,'omitnan');
fid = fopen(['eff_method2.txt'],'w+');
fprintf(fid,'method\tminreversals\tmean\tstd\tN\ttype\tlistener\t\n');
for ir=1:length(minreversals)
for ira=1:length(ratio)
N=avgnumpresentations(ir,ira);
current_mean=means(ir,ira);
std=stds(ir,ira);
fprintf(fid,'SIUD\t%2.0f\t%2.1f\t%2.1f\t%2.1f\tS\t%s\t\n',minreversals(ir),current_mean,std,N,ls{ira});
end
end
fclose(fid);

%% GRaBr
close all
clear
clc
startvalue = 40;
p=[0 1];    
N = 5000;                     % number of MC simulations, more is better but takes more time
L_50s = 15;         % thresholds at the turning point of the psychometric function, here that is at an overall detection rate of 75%
s_50s = 0.5;    
minmeasures = 1;
minreversals = [2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40];
discardreversals=1;
step_size=[8 6 3 1];
level_diff=[8 4 2];
ratio=[0 0.1 0.2]; 
ls={'FC','MC','NC'};


thresholds = nan(numel(minreversals),numel(ratio),N);
numpresentations = zeros(numel(minreversals),numel(ratio),N);
presentstimulus = @(presentation,value, dvalue, first_or_second_level_higher) presentation;
for ir=1:1:length(minreversals)
    for ira=1:length(ratio)
    for in=1:N
    % generate gambling array
    gambling_array = randperm(minreversals(ir)*2,round(minreversals(ir)*ratio(ira)*2));
    virtualanswerersiud2bm2([], [], [],[], L_50s,s_50s,p,gambling_array);
      [threshold, values, reversals, measures, presentations, answers, adjustments] =...
        siud2b(presentstimulus, @virtualanswerersiud2bm2, minreversals(ir), discardreversals, minmeasures, startvalue, step_size,level_diff);
      numpresentations(ir,ira,in) = length(values);
      thresholds(ir,ira,in) = threshold;
      fprintf('.');
    end
      fprintf('\n');
    end
end

means = mean(thresholds,3,'omitnan');
stds = std(thresholds,[],3,'omitnan'); 
avgnumpresentations = mean(numpresentations,3,'omitnan');
fid = fopen(['eff_method2.txt'],'a+');
for ir=1:length(minreversals)
for ira=1:length(ratio)
N=avgnumpresentations(ir,ira);
current_mean=means(ir,ira);
std=stds(ir,ira);
fprintf(fid,'SIUD2b\t%2.0f\t%2.1f\t%2.1f\t%2.1f\tS\t%s\t\n',minreversals(ir),current_mean,std,N,ls{ira});
end
end
fclose(fid);


%% SIAM
close all
clear
clc
target = 0.75; % 87.5%, i.e., the equivalent to a 75% point on a psychometric function between 0 and 100%
startvalue = 40;
feedback = 0;

L_50s = 15;         % thresholds at the turning point of the psychometric function, here that is at an overall detection rate of 75%
s_50s = 0.5;         % slopes, change dependent on the task                
N =5000;            % number of MC simulations, more is better but takes more time
minmeasures = 1;
minreversals = [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
discardreversals=1;
steps =[4 4 2 1];
p = [0.5 1]; 
ratio=[0 0.1 0.2]; 
ls={'FC','MC','NC'};

thresholds = nan(N,1);
numpresentations = nan(N,1);
presentstimulus = @(presentation,value) presentation;

for ir=1:1:length(minreversals)
 for ira=1:length(ratio)
    for in=1:N
    gambling_array = randperm(minreversals(ir)*5,round(minreversals(ir)*ratio(ira)*5));
    virtualanswererm2([], [], [],L_50s,s_50s,p,gambling_array);
      [threshold, values, reversals, measures, presentations, answers, adjustments] =...
        siam(presentstimulus, @virtualanswererm2, target, minreversals(ir), discardreversals, minmeasures, startvalue, steps, feedback);
      numpresentations(ir,ira,in) = length(values);
      thresholds(ir,ira,in) = threshold;
      fprintf('.');
    end
      fprintf('\n');
 end
end
 
 
means = mean(thresholds,3,'omitnan');
stds = std(thresholds,[],3,'omitnan'); 
avgnumpresentations = mean(numpresentations,3,'omitnan');
fid = fopen(['eff_method2.txt'],'a+');
for ir=1:length(minreversals)
 for ira=1:length(ratio)
N=avgnumpresentations(ir,ira);
current_mean=means(ir,ira);
std=stds(ir,ira);
fprintf(fid,'SIAM\t%2.0f\t%2.1f\t%2.1f\t%2.1f\tS\t%s\t\n',minreversals(ir),current_mean,std,N,ls{ira});
end
end
fclose(fid);

%% MLP

close all
clear
clc

discardreversals = 0;
target=0.6310;
startvalue=-60;
offset=100; 
minreversals = 1;

L_50s = 15;         % thresholds at the turning point of the psychometric function, here that is at an overall detection rate of 75%
s_50s = 0.5;    
N = 5000;                     % number of MC simulations, more is better but takes more time
minmeasures = [5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80];
steps=1;
ratio=[0 0.1 0.2]; 
p=[0 1];
ls={'FC','MC','NC'};  

thresholds = nan(N,3);
numpresentations = nan(N,3);
presentstimulus = @(presentation,value) presentation;
for im=1:length(minmeasures)
for ira=1:length(ratio)
    for in=1:N
    gambling_array = randperm(minmeasures(im),round(minmeasures(im)*ratio(ira)));
    virtualanswererm2([], [], [], L_50s,s_50s,p,gambling_array);
      % do the in-th MC simulation
      [threshold, values, reversals, measures, presentations, answers, adjustments] =...
        mlp(presentstimulus, @virtualanswererm2, target,minreversals, discardreversals, minmeasures(im), startvalue, offset,steps);
      numpresentations(im,ira,in) = length(values);
      thresholds(im,ira,in) = threshold;
      fprintf('.');
    end
    fprintf('\n');
end
end

means = mean(thresholds,3,'omitnan');
stds = std(thresholds,[],3,'omitnan'); 
avgnumpresentations = mean(numpresentations,3,'omitnan');
fid = fopen(['eff_method2.txt'],'a+');
for im=1:length(minmeasures)
 for ira=1:length(ratio)
N=avgnumpresentations(im,ira);
current_mean=means(im,ira);
std=stds(im,ira);
fprintf(fid,'MLP\t%2.0f\t%2.1f\t%2.1f\t%2.1f\tS\t%s\t\n',minmeasures(im),current_mean,std,N,ls{ira});
end
end
fclose(fid);


%% APTA
close all
clear
clc
maxTrials=30;
firstLevelDBHL=-10;
repeatLevelDBHL=5;
startLevelDBHL=-10;
discardreversals=0;
L_50s = 15;         % thresholds at the turning point of the psychometric function, here that is at an overall detection rate of 75%
s_50s = 0.5;          % slopes, change dependent on the task
N = 5000;                     % number of MC simulations, more is better but takes more time
maxLevelDev = 3;
minTrials =7;
dBstep=[1 1.2 1.5 2 3 4 5 6 7 8];
minmeasures=[80 70 60 45 35 28 26 23 21 20];

ratio=[0 0.1 0.2]; 
p=[0 1];
ls={'FC','MC','NC'};  

thresholds = nan(N,3);
numpresentations = nan(N,3);
presentstimulus = @(presentation,value) presentation;
    % this uses a persistent variable to store the configuration
    presentstimulus = @(presentation,value) presentation;
    for id=1:length(dBstep)
    for ira=1:length(ratio)
    for in=1:N
      % do the in-th MC simulation
    gambling_array = randperm(minmeasures(id),round(minmeasures(id)*ratio(ira)));
    virtualanswererm2([], [], [], L_50s,s_50s,p,gambling_array);
      [threshold, values, reversals, measures, presentations, answers, adjustments]=apta(presentstimulus, @virtualanswererm2,discardreversals,firstLevelDBHL,maxTrials,minTrials,repeatLevelDBHL,startLevelDBHL,dBstep(id),maxLevelDev);
       numpresentations(id,ira,in) = length(values);
      thresholds(id,ira,in) = threshold;
      fprintf('.');
    end
      fprintf('\n');
    end
    end
    
means = mean(thresholds,3,'omitnan');
stds = std(thresholds,[],3,'omitnan'); 
avgnumpresentations = mean(numpresentations,3,'omitnan');
fid = fopen(['eff_method2.txt'],'a+');
for id=1:length(dBstep)
for ira=1:length(ratio)
N=avgnumpresentations(id,ira);
current_mean=means(id,ira);
std=stds(id,ira);
fprintf(fid,'APTA\t%2.1f\t%2.1f\t%2.1f\t%2.1f\tS\t%s\t\n',dBstep(id),current_mean,std,N,ls{ira});
end
end
fclose(fid);

%% QUEST+
close all
clear
clc

% Set up simulations  
N = 5000;                   
L_50 = 15;  
p2 = 0;
minmeasures = [5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80];
ratio = [0.2,0.1,0]; 
ls={'NC','MC','FC'};

% Set model
F = @(L,L_50,p2)  (1-p2)*1./ ( 1 + exp(1.*0.5.*(L_50-L)));

% set stopping rule and criterion
stopRule='ntrials';

thresholds = nan(numel(minmeasures),numel(ratio),N);
numpresentations = zeros(numel(minmeasures),numel(ratio),N);

% create QUEST+ object
stimDomain = linspace(-10, 50, 61);
paramDomain = {linspace(-10, 50,61),p2};
respDomain = [0 1];


for im=1:1:length(minmeasures)
    % specify N of trials
    stopCriterion=minmeasures(im);
    for ir=1:length(ratio)
    for in=1:N
        
    QP = QuestPlus(F, stimDomain, paramDomain, respDomain, stopRule,stopCriterion);
     % initialise (with default, uniform, prior)
    QP.initialise();
      % run
      startGuess_mean = QP.getParamEsts('mean');
      startGuess_mode = QP.getParamEsts('mode');        

    count = 1;
    % generate gambling array
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
         
      numpresentations(im,ir,in) = stopCriterion;
      thresholds(im,ir,in) = endGuess_mean(1);
      fprintf('.');
    end
      fprintf('\n');
    end
end

means = mean(thresholds,3,'omitnan');
stds = std(thresholds,[],3,'omitnan'); 
avgnumpresentations = mean(numpresentations,3,'omitnan');
fid = fopen(['eff_quest_method2.txt'],'w+');
fprintf(fid,'method\tminreversals\tmean\tstd\tN\ttype\tlistener\t\n');
for im=1:length(minmeasures)
for ir=1:length(ratio)
N=avgnumpresentations(im,ir);
current_mean=means(im,ir);
std=stds(im,ir);
fprintf(fid,'QUEST\t%2.0f\t%2.1f\t%2.1f\t%2.1f\tS\t%s\t\n',N/2,current_mean,std,N,ls{ir});
end
end
fclose(fid);

%% UML
close all
clear
clc

% Set up simulations  
N = 5000;                   
minmeasures = [5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80];
ratio = [0.2,0.1,0]; 
ls={'NC','MC','FC'};


thresholds = nan(numel(minmeasures),numel(ratio),N);
numpresentations = zeros(numel(minmeasures),numel(ratio),N);


for im=1:1:length(minmeasures)
    % specify N of trials
    ntrials=minmeasures(im);
    for ir=1:length(ratio)
    for in=1:N
     
    % do the in-th MC simulation
      
    uml = UML(exp_config_logit());
    uml.setPhi0([15 0.5 0 0]); 
    gambling_array = randperm(ntrials,round(ntrials*ratio(ir)));  
    for i = 1:ntrials 

    % present the stimulus and collect the observer's response r in in
    % terms of correct (1) or incorrect (0).
    r = uml.simulateResponse(uml.xnext);
    
    if ismember(i,gambling_array)
         r =round(rand);
    end
    % update the signal level
    uml.update(r);
    end
    
    numpresentations(im,ir,in) = ntrials;
    thresholds(im,ir,in) = uml.phi(ntrials,1);
    fprintf('.');
    end
    fprintf('\n');
    end
end

means = mean(thresholds,3,'omitnan');
stds = std(thresholds,[],3,'omitnan'); 
avgnumpresentations = mean(numpresentations,3,'omitnan');
fid = fopen(['eff_uml_method2.txt'],'w+');
fprintf(fid,'method\tminreversals\tmean\tstd\tN\ttype\tlistener\t\n');
for im=1:length(minmeasures)
for ir=1:length(ratio)
N=avgnumpresentations(im,ir);
current_mean=means(im,ir);
std=stds(im,ir);
fprintf(fid,'UML\t%2.0f\t%2.1f\t%2.1f\t%2.1f\tS\t%s\t\n',N/2,current_mean,std,N,ls{ir});
end
end
fclose(fid);