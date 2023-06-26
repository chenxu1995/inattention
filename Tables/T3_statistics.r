# load library
library(tidyverse)
library(dplyr)
library(rstatix)
library(multcomp)
library(readxl)

# read data
data <- read.csv("../data/ep2/eff_data_5000.csv")

# filter out GRaBr-O
data <-data %>% filter(method!='GRaBr-O')
# set method to factor
data$method <-factor(data$method, levels = c("SIUD", "GRaBr","APTA",'QUEST+','UML','MLP',"SIAM"))


# anova test
res.aov <- data %>% anova_test(std ~ type*listener*method)
res.aov

# pair-wise t test
stat.test <- data %>%
  group_by(type,listener) %>%
  pairwise_t_test(
    std ~ method,  pool.sd = FALSE,
    p.adjust.method = "bonferroni"
  )

# select interesting columns, round the value (1 decimal)
T3<-stat.test[,c('listener','type','group1','group2','statistic','p.adj.signif')]
T3$statistic<-format(round(T3$statistic,1),nsmall=1)
# paste significance level to t value
T3$tvalue<-paste(T3$statistic,T3$p.adj.signif,sep="")
T3_output<-T3[,c('listener','type','group1','group2','tvalue')]

# export t value results
write.csv(T3_output, "table3.csv", row.names=FALSE)

