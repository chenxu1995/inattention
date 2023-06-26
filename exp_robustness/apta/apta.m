function [threshold, values, reversals, measures, presentations, answers, adjustments] =...
  apta(presentationhandle, answerhandle, discardreversals,firstLevelDBHL,maxTrials,minTrials,repeatLevelDBHL,startLevelDBHL,dBstep,maxLevelDev)
%%define some parameters -->dBHL (units)
%minTrials=3;
%maxTrials=7;
%maxLevelDev=1;
%firstLevelDBHL=-20;
%repeatLevelDBHL=15;
%dBstep=2;
%startLevelDBHL=-20;


% Initial values
value = firstLevelDBHL+round(5*(-1+2*rand));
direction = [];
count = 0;

threshold = [];
values = [];
reversals = [];
measures = [];
presentations = [];
answers = [];
adjustments = [];
num_trial=1;

threshold = nan;  
while num_trial<maxTrials
    
    count = count + 1;
    presentation = 1;
    offset = presentationhandle(presentation, value);
    presentations(count) = presentation;
    values(count) = value;
    
    
      
    % Get answer
    answer = answerhandle(count, presentation, value);
    answers(count) = answer;
  
    % Determine adjustment
    adjustment=level_control_apta(values,answers,repeatLevelDBHL,startLevelDBHL,dBstep);
    adjustments(count) = adjustment;
  
    % Apply adjustment
    value = value + adjustment;
  
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
  % Terminate the measurements
    num_trial=nnz(answers);
    if num_trial>=minTrials
    local_max=values(answers >0);
    if abs(local_max(end)-local_max(end-1))<=maxLevelDev
        threshold=local_max(end);
        break
    end
    end
end

end
