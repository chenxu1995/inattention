function [threshold, values, reversals, measures, presentations, answers, adjustments] =...
  siud(presentationhandle, answerhandle, minreversals, discardreversals, minmeasures, startvalue, steps)

%suggested config
%discardreversals = 2;
%minreversals = 14;
%minmeasures = 25;
%startvalue = 20;
%steps = [10 5 2];



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

assert(discardreversals>=0 && discardreversals<minreversals);
assert(minmeasures >= 1);

abort = false;

% Measure loop
while sum(abs(reversals))<minreversals || sum(presentations(measures==1))<minmeasures && (~abort)
  count = count + 1;
  % Present random stimulus after third presentation
    if count < 4
      presentation = 1;
    else
        presentation = rand(1) > 0.2;
    end
  
  offset = presentationhandle(presentation, value);
  presentations(count) = presentation;
  values(count) = value;
  
  % Get answer
  answer = answerhandle(count, presentation, value);
  if answer == 2
      if presentation == 1 
        answer = 1;
      else
        abort = true;
      end
  else
      answer =0;
  end
  answers(count) = answer;
  % Determine adjustment
  adjustment=next_step_adjustment(answers,steps);
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
end

% Evaluate measurement
threshold = nan;
if sum(abs(reversals))>=minreversals && sum(measures)>=minmeasures && ~abort
  reversalvalues = values(logical(abs(reversals)));
  usereversalvalues = reversalvalues(1+discardreversals:end);
  threshold = median(usereversalvalues);
end
end


