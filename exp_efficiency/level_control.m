function level=levelcontrol(answers,level,level_diff,step_size)
len_answers=length(answers);
switch length(find(answers < 2))
    case 0
           level.up(end+1)=level.up(end)-step_size(1);
           level.down(end+1)=level.down(end)-step_size(1);
% first phase --> check one tone or none
    case 1 
           index_less_two=find(answers < 2);
           if index_less_two == len_answers
              switch answers(end) %current answer equal one
                  case 1
                level.up(end+1)=level.up(end);
                level.down(end+1)=level.up(end)-level_diff(3);
                  case 0
                level.up(end+1)=level.up(end)+level_diff(2); 
                level.down(end+1)=level.up(end)-level_diff(3);
              end
% second phase               
           else
                level.up(end+1)=level.up(end)-step_size(2); 
                level.down(end+1)=level.down(end)-step_size(2);
                
           end
        
    otherwise 
           index_less_two=find(answers < 2);
           if index_less_two == len_answers
                level.down(end+1)=(level.up(end)+level.down(end))/2;
                level.up(end+1)=level.down(end)+level_diff(1);
         
% second phase               
           else
                     if answers(size(answers,2))==2
                         level.down(end+1)=level.down(end)-step_size(3);
                         level.up(end+1)=level.down(end)+level_diff(1);
                     else
                         level.down(end+1)=level.down(end)+step_size(3);
                         level.up(end+1)=level.down(end)+level_diff(1);
          
      end
           end

end
