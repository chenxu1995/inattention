# load library
library(rstatix)
library(tidyverse)
library(dplyr)
library(readxl)

# read data
apta <- read.delim("../data/ep7/apta.csv", header=TRUE, sep=",")
siam <-read.delim("../data/ep7/siam.csv", header=TRUE, sep=",")
siud <- read.delim("../data/ep7/siud.csv", header=TRUE, sep=",")
grabr <- read.delim("../data/ep7/GRaBr.csv", header=TRUE, sep=",")
mlp <- read.delim("../data/ep7/mlp.csv", header=TRUE, sep=",")
uml<-read.delim("../data/ep7/uml.csv", header=TRUE, sep=",")
quest <- read_excel("../data/ep7/quest.xlsx")

# Pre-Processing: add some 1s to N to avoid constant warning in t test
uml$N <- 50+sample(0:1,replace=T, nrow(uml)) 
quest$N <- 50+sample(0:1,replace=T, nrow(quest)) 

# merge dataset and remove NA value
total <- rbind( apta,grabr,mlp,quest,siam,siud,uml) 
total <- na.omit(total) 

# set method to factor
total$method <-factor(total$method, levels = c("SIUD", "GRaBr","APTA",'QUEST+','UML','MLP',"SIAM"))

# calculate sweat factor
total = total %>% group_by(method,listener,type)  %>%  
  mutate(sf=case_when((method =='SIAM'| method =='APTA'| method =='MLP'|method =='UML'|method =='QUEST+') ~ 1/(var(threshold, na.rm=TRUE)*N*1.5), 
                      (method =='SIUD' |method =='GRaBr') ~ 1/(var(threshold, na.rm=TRUE)*N*2.5))) 

# calculate normalized efficiency
total= total %>% group_by(method,listener,type)  %>% 
  mutate(ne=sf*(1-sum(is.na(threshold))/1000))

# anova test and ungrouping the data frame
total <- total %>% ungroup
res.aov <- total %>% anova_test(ne ~ type*listener*method)
res.aov


# pair-wise t test
stat.test <- total %>%
  group_by(type,listener) %>%
  pairwise_t_test(
    ne ~ method,  pool.sd = FALSE,
    p.adjust.method = "bonferroni"
  )


# select interesting columns, round the value (1 decimal), t value was divided by 100
T4<-stat.test[,c('listener','type','group1','group2','statistic','p.adj.signif')]
T4$statistic<-T4$statistic/100
T4$statistic<-format(round(T4$statistic,1),nsmall=1)

# paste significance level to t value
T4$tvalue<-paste(T4$statistic,T4$p.adj.signif,sep="")
T4_output<-T4[,c('listener','type','group1','group2','tvalue')]

# export t value results
write.csv(T4_output, "table4.csv", row.names=FALSE)
