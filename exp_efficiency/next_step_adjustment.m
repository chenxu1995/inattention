function change= next_step_adjustment(answer,step_size)
if all(answer) == 1
    change= -step_size(1);
else 
  first_reversal = find(answer==0, 1, 'first');
  if first_reversal == size(answer,2)
      change= +step_size(2);
  elseif first_reversal < size(answer,2)
      if answer(size(answer,2))==1
          change = -step_size(3);
      else change = +step_size(3);
      end
  end
end
end
