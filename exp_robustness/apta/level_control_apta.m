function adjustment=level_control_apta(levels,answers,repeatLevelDBHL,startLevelDBHL,dBstep)
num_trial=nnz(answers);
switch answers(end)
    case 0
     next_level=levels(end)+dBstep;
    case 1
        switch num_trial
         case 1
             next_level=startLevelDBHL;
         otherwise
             next_level=levels(end)-repeatLevelDBHL;
        end
end
adjustment=next_level-levels(end);
end
