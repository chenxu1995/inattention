# load library
library(ggplot2)
library(ggsci)
library(ggpubr)
library(dplyr)
library(rstatix)
library(readxl)

# import data
apta <- read.delim("../data/ep7/apta.csv", header=TRUE, sep=",")
siam <-read.delim("../data/ep7/siam.csv", header=TRUE, sep=",")
siud <- read.delim("../data/ep7/siud.csv", header=TRUE, sep=",")
grabr <- read.delim("../data/ep7/GRaBr.csv", header=TRUE, sep=",")
mlp <- read.delim("../data/ep7/mlp.csv", header=TRUE, sep=",")
uml<-read.delim("../data/ep7/uml.csv", header=TRUE, sep=",")
quest <- read_excel("../data/ep7/quest.xlsx")

# merge data, and remove na value
total <- rbind(apta,grabr,mlp,quest,siam,siud,uml) 
total <- na.omit(total) 

# Modify the names of NC, FC, and MC
total$listener[total$listener == "NC"] <- "Non Concentrated"
total$listener[total$listener == "FC"] <- "Fully Concentrated"
total$listener[total$listener == "MC"] <- "Moderately Concentrated"


# calculate sweat factor
total =total %>% group_by(method,listener,type)  %>%  
  mutate(sf=case_when((method =='SIAM'| method =='APTA'| method =='MLP'|method =='QUEST+'|method=='UML') ~ 1/(var(threshold, na.rm=TRUE)*N*1.5), 
                      (method =='SIUD'| method =='GRaBr') ~ 1/(var(threshold, na.rm=TRUE)*N*2.5))) 

# calculate normalized efficiency
total=total %>% group_by(method,listener,type)  %>% 
  mutate(ne=sf*(1-sum(is.na(threshold))/1000))

# calculate ne summary
ne_summary <-total %>%
  group_by(method,listener,type) %>%
  summarise(
    sd = sd(ne),
    ne = mean(ne)
  )
# reorder and rename NC, FC, and MC
ne_summary$method <-factor(ne_summary$method, levels = c("SIUD", "GRaBr","APTA",'QUEST+','UML','MLP',"SIAM"))

# plot barplot of normalized efficiency
bp<-ggplot(data = ne_summary, aes(x = method, y=ne, color=listener,linetype = type)) +geom_bar(stat="identity",fill="white", position=position_dodge(),lwd=1)+scale_color_jco() 
bp<-bp+geom_errorbar(aes(ymin=ne, ymax=ne+sd), width=.5,
                     position=position_dodge(0.9),lwd=1) + theme(text = element_text(size = 16))+ labs(y = "Normalised Efficiency")
bp<-bp+theme_classic() +theme(legend.position="bottom") + theme(text = element_text(size = 16))+scale_linetype_discrete(name = "type",labels= c("Long-term inattentive", "Short-term inattentive"))
bp<- bp+theme(legend.position = "bottom",
          legend.box = "vertical")

bp

# Apply statistics
stat.test <- total %>%
  group_by(type,listener) %>%
  pairwise_t_test(
    ne ~ method,
    p.adjust.method = "bonferroni"
  )%>%filter(type=='S'& listener =="Non Concentrated")%>%add_xy_position(x = "method")

# Adjust bar
stat.test$xmin<-stat.test$xmin+0.35
stat.test$xmax<-stat.test$xmax+0.35

# add statistical label
bp<-bp+ stat_pvalue_manual(stat.test, y.position=0.035,color='listener',linetype ='type',label = "p.adj.signif",step.increase = 0.05,tip.length = 0, hide.ns = TRUE)

# Annotate number of simulation and number of trial
bp+ annotate("text",x =5, y = 0.04,
                    label = c('Number of trials = 50\nNumber of simulations = 1000\n'),hjust = 0,size=4) 

