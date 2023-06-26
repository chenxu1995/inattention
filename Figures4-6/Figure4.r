# load library
library(ggplot2)
library(ggsci)
library(ggpubr)
library(dplyr)
library(rstatix)
library(ggsignif)
library(readxl)

# read data
apta <- read.delim("../data/ep7/apta.csv", header=TRUE, sep=",")
siam <-read.delim("../data/ep7/siam.csv", header=TRUE, sep=",")
siud <- read.delim("../data/ep7/siud.csv", header=TRUE, sep=",")
grabr <- read.delim("../data/ep7/GRaBr.csv", header=TRUE, sep=",")
mlp <- read.delim("../data/ep7/mlp.csv", header=TRUE, sep=",")
uml<-read.delim("../data/ep7/uml.csv", header=TRUE, sep=",")
quest <- read_excel("../data/ep7/quest.xlsx")

# merge data set and remove NA
total <- rbind( apta,grabr,mlp,quest,siam,siud,uml) 
total<- na.omit(total) 

# set method to factor
total$method <-factor(total$method, levels = c("SIUD", "GRaBr","APTA",'QUEST+','UML','MLP',"SIAM"))

# Modify the names of NC, FC, and MC
total$listener[total$listener == "NC"] <- "Non Concentrated"
total$listener[total$listener == "FC"] <- "Fully Concentrated"
total$listener[total$listener == "MC"] <- "Moderately Concentrated"

# Plot 
bxp <- ggboxplot(
  total , x = "method", y = "threshold",palette = "jco",
  color = "listener",linetype="type",outlier.shape = NA,lwd=1
)+theme_classic()+ theme(text = element_text(size = 16))
bxp<-bxp+labs(y= "Threshold Estimates / dB")+ theme(legend.position="bottom")+ geom_hline(yintercept=15, linetype="longdash", color ='#e73550',lwd=1)
bxp<- bxp+scale_linetype_discrete(name = "type",labels= c("Long-term inattentive", "Short-term inattentive"))


bxp
# Apply statistics
stat.test <- total %>%
  group_by(type,listener) %>%
  pairwise_t_test(
    threshold ~ method,  pool.sd = FALSE,
    p.adjust.method = "bonferroni"
  )%>%filter(type=='S'& listener =="Non Concentrated")%>%add_xy_position(x = "method")

# Adjust x position
stat.test$xmin<-stat.test$xmin+0.35
stat.test$xmax<-stat.test$xmax+0.35

# Add statistical labels
bxp <-bxp + stat_pvalue_manual(stat.test, hide.ns = TRUE,y.position=25,color='listener',linetype ='type',label = "p.adj.signif",step.increase = 0.01,tip.length = 0)+ theme(legend.position = "bottom",legend.box = "vertical")+ylim(10,70)

# Annotate number of simulation and number of trial
bxp <-bxp+ annotate("text",x =1, y = 55,
                 label = c('Number of trials = 50\nNumber of simulations = 1000\nTarget threshold = 15 dB'),hjust = 0,size=4) 

# disable xlab
bxp<-bxp+theme(axis.title.x=element_blank(),axis.ticks.x=element_blank())
bxp

