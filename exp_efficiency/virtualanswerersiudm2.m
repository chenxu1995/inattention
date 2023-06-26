function out = virtualanswerersiudm2(count, presentation, value,dvalue, L_50, s_50,p,gambling_array)
  persistent cache; % this variable is not freed after this function ends

  % fill cache
  if nargin > 4
    cache.L_50 = L_50;
    cache.s_50 = s_50;
    cache.p = p;
    cache.gambling_array=gambling_array;
  else
    L_50 = cache.L_50;
    s_50 = cache.s_50;
    p= cache.p;
    gambling_array=cache.gambling_array;
  end

  if isempty(presentation)
    answer = '';
    return
  end
  
  if ismember(count,gambling_array)
     out= randi([0,2]);
  else
  
  out = 0;
  if presentation == 1
    if rand(1) < sigmoid(value, L_50, s_50, p)
      out =out+ 1;
    end
  end
  if rand(1) < sigmoid(value+10, L_50, s_50, p)
    out =out+ 1;
  end
  end
end

function out = sigmoid(L, L_50, s_50, p)
  out = 1./ ( 1 + exp(1.*s_50.*(L_50-L)) );
  out = out * (p(2)-p(1))+p(1);
end
