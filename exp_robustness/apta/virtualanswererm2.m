function answer = virtualanswererm2(count, presentation, value,L_50, s_50, p,gambling_array)
  persistent cache; % this variable is not freed after this function ends

  % fill cache
  if nargin > 3
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
     answer=round(rand);
  else
  answer = presentation;
  if rand(1) > sigmoid(value, L_50, s_50, p)
    answer = ~presentation;
  end
  end
end

function out = sigmoid(L, L_50, s_50, p)
  out = 1./ ( 1 + exp(1.*s_50.*(L_50-L)) );
  out = out * (p(2)-p(1))+p(1);
end

