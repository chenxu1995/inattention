L_50=10;
s_50=0.5;
p=[0 1];
step=1;

target=0.6310;
startvalue=-5;
offset=100; 

minreversals =4;
discardreversals = 1;
minmeasures = 15;

virtualanswerer([], [], [], L_50, s_50, p);
 presentstimulus = @(presentation,value) presentation;

[threshold, values, reversals, measures, presentations, answers, adjustments]=mlp(presentstimulus, @virtualanswerer, target, minreversals, discardreversals, minmeasures, startvalue,offset,step);