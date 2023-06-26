# load library
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
  group_by(type,listener,method) %>%
  summarise(
    sd = sd(ne),
    ne = mean(ne)
  )
# reorder and rename NC, FC, and MC
ne_summary$method <-factor(ne_summary$method, levels = c("SIUD", "GRaBr","APTA",'QUEST+','UML','MLP',"SIAM"))
