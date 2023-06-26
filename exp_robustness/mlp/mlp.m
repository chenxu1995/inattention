function [threshold, values, reversals, measures, presentations, answers, adjustments] =...
 mlp(presentationhandle, answerhandle, target,minreversals, discardreversals, minmeasures,startvalue,offset,step)

%suggested config
%discardreversals = 2;
%minreversals = 14;
%minmeasures = 25;
%startvalue = 65;
%steps = 1;

% Initial values
value = startvalue+round(5*(-1+2*rand));
direction = [];
count = 0;

threshold = [];
values = [];
reversals = [];
measures = [];
presentations = [];
answers = [];
adjustments = [];


% Parameters for maximum likelihood
gamma = [0, 0.1, 0.2, 0.3, 0.4];
lambda=0;
beta=1;
firstmidpoint=-110;
lastmidpoint=-50;
range=abs(firstmidpoint-lastmidpoint);
midpoint=linspace(firstmidpoint,lastmidpoint,range/step);

assert(discardreversals>=0 && discardreversals<minreversals);
assert(minmeasures >= 1);
% Measure loop

while sum(abs(reversals))<minreversals || sum(presentations(measures==1))<minmeasures
  count = count + 1;
  presentation = 1;
  
  presentationhandle(presentation, value);
  presentations(count) = presentation;
  values(count) = value;
  % Get answer
  answer = answerhandle(count, presentation, value+offset);
  answers(count) = answer;
  
  [level, FA] = FindThreshold(target, values, answers, midpoint, beta, gamma, lambda);
  
  adjustment = level-value;
  adjustments(count) = adjustment;
  
  value=level;
   % Detect reversals
  if isempty(direction) && adjustment ~= 0
    direction = adjustment;
  elseif (adjustment>0 && direction<0) || (adjustment<0 && direction>0)
    direction = adjustment;
    reversals(count) = sign(direction);
  else
    reversals(count) = 0;
  end
  
  % Mark measures
  if sum(abs(reversals)) > discardreversals
    measures(count) = 1;
  else
    measures(count) = 0;
  end 
end
% Evaluate measurement
if sum(abs(reversals))>=minreversals && sum(measures)>=minmeasures
  threshold = values(end)+offset;
end
end

