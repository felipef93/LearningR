#Titanic Problem
library(ggplot2)
library(reshape2)
#Importing train data
setwd('C:/Users/GitCodes/LearningR/Titanic')
traindata<-read.csv('train.csv')

##############################################################################################
#                                           Data prep                                        #
##############################################################################################
#Data editing,trimming and melting
#Cabin, PassengerID, ticket and Name were not considered in the modelling
# The following variables were given
# Gender: 0 = Female  1 = Male
# Embarked: 0 = NA  1 = Cherbourg 2 = Queenstown  3 = Southampton

meltdata<-traindata[c(2,3,5,6,7,8,10,12)]
for (n in 1:nrow(meltdata)){
  if(meltdata[n,1]==1) meltdata[n,1]<-"survived"
  else meltdata[n,1]<-"dead"
}
meltdata<-transformnumeric(meltdata,3)
meltdata<-transformnumeric(meltdata,8)
for(n in 2:8) meltdata[[n]]<-as.numeric(meltdata[[n]])
meltdata<-melt(meltdata)
##############################################################################################
#                                           Histogram                                        #
##############################################################################################
ggplot(data=meltdata)+geom_histogram(bins=6,col='black',aes(x=value,fill=Survived))+facet_grid(Survived~variable, scales="free_x")+theme_light()

##############################################################################################
#                                       Tests on the data                                    #
##############################################################################################
#Logistic regression test on age  
model<-glm(Survived~Age,data=traindata,family=binomial)
n<-1
exp(-0.0567-0.0110*n)/(1+exp(-0.0567-0.0110*n))
