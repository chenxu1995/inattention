# load library
library(dplyr)
library(rstatix)
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

# calculate bias
total$bias<-total$threshold-15

# summary statistics
summary.total <-total  %>%
  group_by(type,listener,method) %>%
  get_summary_stats(threshold,type ="robust")
summary.total

