function [threshold, values, dvalues, reversals, measures, presentations, answers, adjustments, offsets] =...
  grabr(presentationhandle, answerhandle, minreversals, discard_reversals, minmeasures, startvalue, level_steps, difference_steps, non_stop)

  if nargin < 9 ; non_stop = false; end

  % Example config
  %  minreversals = 14;
  %  discard_reversals = 4;
  %  minmeasures = 25;
  %  startvalue = 10;
  %  level_steps = [12 6 3 1]; % level difference between the trials
  %  difference_steps = [9 6 3]; % level difference between the two tones per trial

  % Initial values
  value = startvalue + randn(1) * 10;
  dvalue = difference_steps(1);
  direction = [];
  count = 0;

  threshold = [];
  values = [];
  reversals = [];
  measures = [];
  presentations = [];
  answers = [];
  adjustments = [];
  offsets = [];

  assert(discard_reversals>=0 && discard_reversals<minreversals);
  assert(minmeasures >= 1);

  % Measure loop
  count_dlevel_adapt = 1;
  abort = false;
  num_reversals = 0;
  count_prev_answer_was_one_but_two_were_presented = 0;
  num_reversals = 0;
  while ( num_reversals<minreversals || sum(presentations(measures==1))<minmeasures ) && (~abort)
    count = count + 1;
    num_reversals = sum(abs(reversals));

    % Present random stimulus after third presentation
    if count < 4
      presentation = 1;
      first_or_second_level_higher = 1;
    else
      presentation = rand(1) > 0.2;
      first_or_second_level_higher = rand(1)>0.5;
    end
%    offset = presentationhandle(presentation, value, dvalue, first_or_second_level_higher);
    presentations(count) = presentation;
    values(count) = value;
    dvalues(count) = dvalue;
    first_or_second_level_highers(count) = first_or_second_level_higher;
%    offsets(count) = offset;

    answer = answerhandle(count, presentation, value, value-dvalue);
    answers(count) = answer;
    % Determine adjustment
    % this is the current measurement logic.
    adj = 0;
    dval_adj = 0;
    if answer == 2
      if presentation == 1
        % make harder
        adj = -1;
      else % presentation == 0
        % wrong answer, abort
        if non_stop
          adj = 1.5 % make sig. easier (siam-esque approach)
        else
          abort = true;
        end
      end
    elseif answer == 1
      if presentation == 1
        % threshold within range, reduce interval
        count_dlevel_adapt = count_dlevel_adapt + 1;
        dval_adj = dvalue;
        dvalue = difference_steps(min(count_dlevel_adapt, length(difference_steps)));
        dval_adj = -(dval_adj - dvalue)/2;
        % randomly adjust the level when the last answer was also 1 but two were presented
        % ... i am using the assignment operator for incrementing due to the long var name
        count_prev_answer_was_one_but_two_were_presented = count_prev_answer_was_one_but_two_were_presented+1;
        if count_prev_answer_was_one_but_two_were_presented > 1;
          count_prev_answer_was_one_but_two_were_presented = 0;
          adj = sign(randn(1)) * 1 / 4;
        end
      else % presentation == 0
        % catch trial, th1eshold heard, reduce level
        % but only by half since only one tone was presented
        adj = - 1/2;
      end
    else % answer == 0
      if presentation == 1
        % make easier
        adj = + 1;
      else % presentation == 0
        adj = + 1/2;
      end
    end


    % Detect reversals
    if isempty(direction) && adj ~= 0
      direction = adj;
    elseif (adj>0 && direction<0) || (adj<0 && direction>0)
      direction = adj;
      reversals(count) = sign(direction);
    else
      reversals(count) = 0;
    end

    % printf('  Adjustment: %f\n', adjustment);
    adjustment = adj * level_steps(min(num_reversals+1,length(level_steps))) + dval_adj;
    adjustments(count) = adjustment;
    value = value + adjustment;

    % Mark measures
    if sum(abs(reversals)) > discard_reversals
      measures(count) = 1;
    else
      measures(count) = 0;
    end
  end

  % Evaluate measurement
  threshold = nan;
  if sum(abs(reversals))>=minreversals && sum(measures)>=minmeasures && ~abort
    reversal_upper_values = values(logical(abs(reversals)));
    use_reversal_upper_values = reversal_upper_values(1+discard_reversals:end);

    reversal_lower_values = values(logical(abs(reversals))) - dvalues(logical(abs(reversals)));
    use_reversal_lower_values = reversal_lower_values(1+discard_reversals:end);

    use_reversal_values = [use_reversal_upper_values use_reversal_lower_values];
    threshold = median(use_reversal_values);
  end
end
