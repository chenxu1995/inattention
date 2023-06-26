clc;
close all;
clear all;

% set up simulation paramters
ntrials = 50;
N = 1000;
ratio = [0.2,0.1,0]; 
ls={'NC','MC','FC'};

% specify a file 
fid = fopen(['opt_uml_m2.txt'],'w+');
fprintf(fid,'threshold\tN\tmethod\tlistener\ttype\t\n');

thresholds = nan(N,3);
numpresentations = nan(N,3);

for ir=1:length(ratio)
for in = 1:N
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
thresholds(in,ir) = uml.phi(ntrials,1);
numpresentations(in,ir) = ntrials;
fprintf(fid,'%2.1f\t%2.0f\tUML\t%s\tS\t\n',uml.phi(ntrials,1),ntrials,ls{ir});
fprintf('.');
end
fprintf('\n');
end

