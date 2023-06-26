# load library
library(tidyverse)
library(dplyr)
library(rstatix)
library(multcomp)
library(readxl)

apta <- read.delim("../data/ep7/apta.csv", header=TRUE, sep=",")
siam <-read.delim("../data/ep7/siam.csv", header=TRUE, sep=",")
siud <- read.delim("../data/ep7/siud.csv", header=TRUE, sep=",")
grabr <- read.delim("../data/ep7/GRaBr.csv", header=TRUE, sep=",")
mlp <- read.delim("../data/ep7/mlp.csv", header=TRUE, sep=",")
uml<-read.delim("../data/ep7/uml.csv", header=TRUE, sep=",")
quest <- read_excel("../data/ep7/quest.xlsx")

# merge data set
total <- rbind( apta,grabr,mlp,quest,siam,siud,uml) 

# remove na
total <- na.omit(total) 
# set method to factor
total$method <-factor(total$method, levels = c("SIUD", "GRaBr","APTA",'QUEST+','UML','MLP',"SIAM"))

# anova test
res.aov <- total %>% anova_test(threshold ~ type*listener*method)
res.aov

# pair-wise t test
stat.test <- total %>%
  group_by(type,listener) %>%
  pairwise_t_test(
    threshold ~ method,  pool.sd = FALSE,
    p.adjust.method = "bonferroni"
  )
# select interesting columns, round the value (1 decimal)
T2<-stat.test[,c('listener','type','group1','group2','statistic','p.adj.signif')]
T2$statistic<-format(round(T2$statistic,1),nsmall=1)
# paste significance level to t value
T2$tvalue<-paste(T2$statistic,T2$p.adj.signif,sep="")
T2_output<-T2[,c('listener','type','group1','group2','tvalue')]

# export t value results
write.csv(T2_output, "table2.csv", row.names=FALSE)

