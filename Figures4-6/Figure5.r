# load library
library('ggplot2')
library(readr)
library("ggsci")
library(ggh4x)
library(dplyr)
# read data
data <- read.csv("../data/ep2/eff_data_5000.csv")
data$method <-as.factor(data$method)

# filter out grabr-o, and reorder the data
data <-data %>% filter(method!='GRaBr-O')
data$method <-factor(data$method,  levels = c("SIUD", "GRaBr","APTA",'QUEST+','UML','MLP',"SIAM"))

# rename the NC, FC, and MC
data$listener[data$listener == "NC"] <- "Non Concentrated"
data$listener[data$listener == "FC"] <- "Fully Concentrated"
data$listener[data$listener == "MC"] <- "Moderately Concentrated"

# rename Long- and short-term
data$type[data$type == "L"] <- "Long-term inattentive"
data$type[data$type == "S"] <- "Short-term inattentive"


# start plot
p1<- ggplot(data, aes(x=N, y=std, group=method, color=method,shape=method))+ geom_point()+ facet_grid(rows = vars(type),cols = vars(listener))+labs(x="Number of Trials N", y = "Standard Deviation (error in dB)")+theme_classic()+ scale_color_npg()+ theme(legend.position="bottom")
p1<-p1+xlim(10,75) + geom_smooth(formula = y ~ 1/sqrt(x),se = FALSE)+ theme(legend.position = "bottom",
                                  legend.box = "vertical")+ theme(text = element_text(size = 16))
p1<-p1 +
  theme(panel.spacing = unit(.0, "lines"),
        panel.border = element_rect(color = "black", fill = NA, size = 1), 
        strip.background = element_rect(color = "black", size = 1))+geom_vline(xintercept=50,linetype=2)

p1

