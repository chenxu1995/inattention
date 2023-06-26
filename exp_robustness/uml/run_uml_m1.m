clc;
close all;
clear all;

% set up simulation paramters
ntrials = 50;
N = 1000;
p = [0.2,0.1,0];   
ls={'NC','MC','FC'};

% specify a file 
fid = fopen(['opt_uml_m1.txt'],'w+');
fprintf(fid,'threshold\tN\tmethod\tlistener\ttype\t\n');

thresholds = nan(N,3);
numpresentations = nan(N,3);

for ip=1:length(p)
for in = 1:N
uml = UML(exp_config_logit());
uml.setPhi0([15 0.5 0 p(ip)]);
for i = 1:ntrials 
    % present the stimulus and collect the observer's response r in in
    % terms of correct (1) or incorrect (0).
    r = uml.simulateResponse(uml.xnext);
    % update the signal level
    uml.update(r);
    
end
thresholds(in,ip) = uml.phi(ntrials,1);
numpresentations(in,ip) = ntrials;
fprintf(fid,'%2.1f\t%2.0f\tUML\t%s\tL\t\n',uml.phi(ntrials,1),ntrials,ls{ip});
fprintf('.');
end
fprintf('\n');
end

