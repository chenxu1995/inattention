%% SIUD
close all
clear
clc
startvalue = 40;             
N =5000;                     % number of MC simulations, more is better but takes more time
L_50s = 15;         % thresholds at the turning point of the psychometric function, here that is at an overall detection rate of 75%
s_50s = 0.5;    
minmeasures = 1;
minreversals = [2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40];
discardreversals=1;
steps =[10 5 2];
p = {[0 0.8],[0 0.9],[0 1]};   
ls={'NC','MC','FC'};

thresholds = nan(numel(minreversals),numel(p),N);
numpresentations = zeros(numel(minreversals),numel(p),N);

presentstimulus = @(presentation,value) presentation;


for ir=1:1:length(minreversals)
    for ip=1:length(p)
    virtualanswerersiud([], [], [],L_50s,s_50s,p{ip});
    for in=1:N
      % do the in-th MC simulation
      [threshold, values, reversals, measures, presentations, answers, adjustments] =...
        siud(presentstimulus, @virtualanswerersiud, minreversals(ir), discardreversals, minmeasures, startvalue, steps);
      numpresentations(ir,ip,in) = length(values);
      thresholds(ir,ip,in) = threshold;
      fprintf('.');
    end
      fprintf('\n');
    end
    end


means = mean(thresholds,3,'omitnan');
stds = std(thresholds,[],3,'omitnan'); 
avgnumpresentations = mean(numpresentations,3,'omitnan');
fid = fopen(['eff_method1.txt'],'w+');
fprintf(fid,'method\tminreversals\tmean\tstd\tN\ttype\tlistener\t\n');
for ir=1:length(minreversals)
for ip=1:length(p)
N=avgnumpresentations(ir,ip);
current_mean=means(ir,ip);
std=stds(ir,ip);
fprintf(fid,'SIUD\t%2.0f\t%2.1f\t%2.1f\t%2.1f\tL\t%s\t\n',minreversals(ir),current_mean,std,N,ls{ip});
end
end
fclose(fid);

%% GRaBr
close all
clear
clc
startvalue = 40;             
N = 5000;                     % number of MC simulations, more is better but takes more time
L_50s = 15;         % thresholds at the turning point of the psychometric function, here that is at an overall detection rate of 75%
s_50s = 0.5;    
minmeasures = 1;
minreversals = [2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40];
discardreversals=1;
step_size=[8 6 3 1];
level_diff=[8 4 2];
p = {[0 0.8],[0 0.9],[0 1]};   
ls={'NC','MC','FC'};

thresholds = nan(numel(minreversals),numel(p),N);
numpresentations = zeros(numel(minreversals),numel(p),N);
presentstimulus = @(presentation,value, dvalue, first_or_second_level_higher) presentation;


for ir=1:1:length(minreversals)
    for ip=1:length(p)
    virtualanswerergrabr([], [], [],[],L_50s,s_50s,p{ip});
    for in=1:N
      % do the in-th MC simulation
      [threshold, values, reversals, measures, presentations, answers, adjustments] =...
        grabr(presentstimulus, @virtualanswerergrabr,minreversals(ir), discardreversals,minmeasures, startvalue, step_size,level_diff);
      numpresentations(ir,ip,in) = length(values);
      thresholds(ir,ip,in) = threshold;
      fprintf('.');
    end
      fprintf('\n');
    end
    end


means = mean(thresholds,3,'omitnan');
stds = std(thresholds,[],3,'omitnan'); 
avgnumpresentations = mean(numpresentations,3,'omitnan');
fid = fopen(['eff_method1.txt'],'a+');
for ir=1:length(minreversals)
for ip=1:length(p)
N=avgnumpresentations(ir,ip);
current_mean=means(ir,ip);
std=stds(ir,ip);
fprintf(fid,'GRaBr\t%2.0f\t%2.1f\t%2.1f\t%2.1f\tL\t%s\t\n',minreversals(ir),current_mean,std,N,ls{ip});
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
N = 5000;            % number of MC simulations, more is better but takes more time
minmeasures = 1;
minreversals = [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
discardreversals=1;
steps =[4 4 2 1];
p = {[0.5 0.8],[0.5 0.9],[0.5 1]};   
ls={'NC','MC','FC'};  

thresholds = nan(N,1);
numpresentations = nan(N,1);
presentstimulus = @(presentation,value) presentation;

for ir=1:1:length(minreversals)
 for ip=1:length(p)
    virtualanswerer([], [], [],L_50s,s_50s,p{ip});
    for in=1:N
      % do the in-th MC simulation
      [threshold, values, reversals, measures, presentations, answers, adjustments] =...
        siam(presentstimulus, @virtualanswerer, target, minreversals(ir), discardreversals, minmeasures, startvalue, steps, feedback);
      numpresentations(ir,ip,in) = length(values);
      thresholds(ir,ip,in) = threshold;
      fprintf('.');
    end
      fprintf('\n');
 end
end
 
 
means = mean(thresholds,3,'omitnan');
stds = std(thresholds,[],3,'omitnan'); 
avgnumpresentations = mean(numpresentations,3,'omitnan');
fid = fopen(['eff_method1.txt'],'a+');
for ir=1:length(minreversals)
for ip=1:length(p)
N=avgnumpresentations(ir,ip);
current_mean=means(ir,ip);
std=stds(ir,ip);
fprintf(fid,'SIAM\t%2.0f\t%2.1f\t%2.1f\t%2.1f\tL\t%s\t\n',minreversals(ir),current_mean,std,N,ls{ip});
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
p = {[0 0.8],[0 0.9],[0 1]};   
ls={'NC','MC','FC'};

thresholds = nan(N,3);
numpresentations = nan(N,3);
presentstimulus = @(presentation,value) presentation;
for im=1:length(minmeasures)
for ip=1:length(p)
    virtualanswerer([], [], [],L_50s,s_50s,p{ip});
    for in=1:N
      % do the in-th MC simulation
      [threshold, values, reversals, measures, presentations, answers, adjustments] =...
        mlp(presentstimulus, @virtualanswerer, target,minreversals, discardreversals, minmeasures(im), startvalue, offset,steps);
       numpresentations(im,ip,in) = length(values);
      thresholds(im,ip,in) = threshold;
      fprintf('.');
    end
    fprintf('\n');
end
end
means = mean(thresholds,3,'omitnan');
stds = std(thresholds,[],3,'omitnan'); 
avgnumpresentations = mean(numpresentations,3,'omitnan');
fid = fopen(['eff_method1.txt'],'a+');
for im=1:length(minmeasures)
for ip=1:length(p)
N=avgnumpresentations(im,ip);
current_mean=means(im,ip);
std=stds(im,ip);
fprintf(fid,'MLP\t%2.0f\t%2.1f\t%2.1f\t%2.1f\tL\t%s\t\n',minmeasures(im),current_mean,std,N,ls{ip});
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
p = {[0 0.8],[0 0.9],[0 1]};   
ls={'NC','MC','FC'};
fid = fopen(['eff_method1.txt'],'a+');
thresholds = nan(N,3);
numpresentations = nan(N,3);
presentstimulus = @(presentation,value) presentation;
    % this uses a persistent variable to store the configuration
    presentstimulus = @(presentation,value) presentation;
    for id=1:length(dBstep)
    for ip=1:length(p)
    virtualanswerer([], [], [],L_50s,s_50s,p{ip}); 
    for in=1:N
      % do the in-th MC simulation
      [threshold, values, reversals, measures, presentations, answers, adjustments]=apta(presentstimulus, @virtualanswerer,discardreversals,firstLevelDBHL,maxTrials,minTrials,repeatLevelDBHL,startLevelDBHL,dBstep(id),maxLevelDev);
       numpresentations(id,ip,in) = length(values);
      thresholds(id,ip,in) = threshold;
      fprintf('.');
    end
      fprintf('\n');
    end
    end
    
means = mean(thresholds,3,'omitnan');
stds = std(thresholds,[],3,'omitnan'); 
avgnumpresentations = mean(numpresentations,3,'omitnan');
fid = fopen(['eff_method1.txt'],'a+');
for id=1:length(dBstep)
for ip=1:length(p)
N=avgnumpresentations(id,ip);
current_mean=means(id,ip);
std=stds(id,ip);
fprintf(fid,'APTA\t%2.1f\t%2.1f\t%2.1f\t%2.1f\tL\t%s\t\n',dBstep(id),current_mean,std,N,ls{ip});
end
end
fclose(fid);

%% QUEST+
close all
clear
clc

% Set up simulations
N =5000;                     
L_50 = 15;       
minmeasures = [5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80];
p = [0.2,0.1,0];   
ls={'NC','MC','FC'};
thresholds = nan(numel(minmeasures),numel(p),N);
numpresentations = zeros(numel(minmeasures),numel(p),N);

% Set model
F = @(L,L_50,p2)  (1-p2)*1./ ( 1 + exp(1.*0.5.*(L_50-L)));

% set stopping rule and criterion
stopRule='ntrials';

% create QUEST+ object
stimDomain = linspace(-10, 50, 61);
respDomain = [0 1];

for im=1:1:length(minmeasures)
    stopCriterion=minmeasures(im);
    for ip=1:length(p)
    for in=1:N
      % do the in-th MC simulation
      
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
      
      thresholds(im,ip,in) = endGuess_mean(1);
      numpresentations(im,ip,in) = stopCriterion;
      fprintf('.');
    end
      fprintf('\n');
    end
    end


means = mean(thresholds,3,'omitnan');
stds = std(thresholds,[],3,'omitnan'); 
avgnumpresentations = mean(numpresentations,3,'omitnan');
fid = fopen(['eff_method1.txt'],'a+');
for im=1:length(minmeasures)
for ip=1:length(p)
N=avgnumpresentations(im,ip);
current_mean=means(im,ip);
std=stds(im,ip);
fprintf(fid,'QUEST\t%2.0f\t%2.1f\t%2.1f\t%2.1f\tL\t%s\t\n',N/2,current_mean,std,N,ls{ip});
end
end
fclose(fid);    

%% UML
close all
clear
clc

% Set up simulations
N =5000;                           
minmeasures = [5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80];
p = [0.2,0.1,0];   
ls={'NC','MC','FC'};

% create a vector for saving the data
thresholds = nan(numel(minmeasures),numel(p),N);
numpresentations = zeros(numel(minmeasures),numel(p),N);


for im=1:1:length(minmeasures)
    ntrials=minmeasures(im);
    for ip=1:length(p)
    for in=1:N
      % do the in-th MC simulation
      
    uml = UML(exp_config_logit());
    uml.setPhi0([15 0.5 0 p(ip)]); 
 
    for i = 1:ntrials 
    % present the stimulus and collect the observer's response r in in
    % terms of correct (1) or incorrect (0).
    r = uml.simulateResponse(uml.xnext);
    % update the signal level
    uml.update(r);
    end
                
      thresholds(im,ip,in) = uml.phi(ntrials,1);
      numpresentations(im,ip,in) = ntrials;
      fprintf('.');
    end
      fprintf('\n');
    end
    end


means = mean(thresholds,3,'omitnan');
stds = std(thresholds,[],3,'omitnan'); 
avgnumpresentations = mean(numpresentations,3,'omitnan');
fid = fopen(['eff_method1.txt'],'a+');
for im=1:length(minmeasures)
for ip=1:length(p)
N=avgnumpresentations(im,ip);
current_mean=means(im,ip);
std=stds(im,ip);
fprintf(fid,'UML\t%2.0f\t%2.1f\t%2.1f\t%2.1f\tL\t%s\t\n',N/2,current_mean,std,N,ls{ip});
end
end
fclose(fid);
