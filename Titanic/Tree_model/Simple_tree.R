library(rpart)
library(randomForest)
library(RRF)
#Importing train data
setwd('C:/Users/GitCodes/LearningR/Titanic')
traindata<-read.csv('train.csv')
testdata<-read.csv('test.csv')
##############################################################################################
#                                           Data prep                                        #
##############################################################################################
#Selection of only relevant information
traindata2<-traindata[c(2,3,5,6,7,8,10,12)]
traindata2<-transformnumeric(traindata2,3)
traindata2<-transformnumeric(traindata2,8)
write.csv(traindata2,file="Tree_model/clean_data.csv",row.names = FALSE)
##############################################################################################
#                                         Tree Modelling                                     #
##############################################################################################
testtree<-rpart(Survived~.,method="class",data=traindata2)#Partitioning to a tree
#Tree plot
plot(testtree, uniform=TRUE, margin=0.1)
text(testtree)        

##############################################################################################
#                                         Tree Pruning                                       #
##############################################################################################
#Analysis of the results
#CP= complexity parameter -> basically by how much would it improve to have another leaf on
#on the tree
plotcp(testtree) #Plot ???of Cp
testtree$cptable #Errors of each partitioning
# Remove leafs that are not very usefull, thus decreasing the probability of overfitting
#Tree was pruned based on the CP plot, as having more than 5 branches seemed unecassary
fit.pruned <- prune(testtree, cp = testtree$cptable[5, "CP"])

#Prunned tree plot
plot(fit.pruned, uniform = TRUE, margin = 0.1, main = "Pruned Tree")
text(fit.pruned)

##############################################################################################
#                                     Applying the model                                     #
##############################################################################################
#Data prep
testadjusted<-testdata[c(2,4,5,6,7,9,11)]
testadjusted<-transformnumeric(testadjusted,2)
testadjusted<-transformnumeric(testadjusted,7)

#prediction based on pruned model
prediction<-as.numeric(predict(fit.pruned,testadjusted,type="class"))-1 #Note that as Survived
                                        #Is a factor its transformed, the -1 was just an easy
                                        #solution to have 0 and 1 as R returns 1 and 2s
##############################################################################################
#                                     Exporting the data                                     #
##############################################################################################

submission<-matrix(nrow=418,ncol=2) #Creation of matrix to store data
submission[,1]<-testdata[,1] 
submission[,2]<-prediction
submission<-as.data.frame(submission) #Matrix transformed to data frame
names(submission)<-c("PassengerId","Survived")#And given correct names

write.csv(submission,file="submission.csv",row.names = FALSE) #Export as csv file
#This model has accuracy 0.77990

##############################################################################################
#                                         Random Forest                                      #
##############################################################################################
traindata2<-traindata2[complete.cases(traindata2),]
traindata2[,1]<-as.factor(traindata2[,1])

set.seed(123)
#Note that importance and do trace are both very good ways of actually seeing what's happening
#the first allows to see what variable do the forest prioritize, the second if number of trees
#would increase the model
forestR<-randomForest(Survived~.,data=traindata2,mtry=3,ntree=500,importance=T,do.trace=100)
#Another good parameter to look at is the confusion matrix which shows the possibility of
#false positives and false negatives
print(forestR)
print(forestR$importance)
prediction.rf <- predict(forestR, testdata)

submission2<-matrix(nrow=418,ncol=2)
submission2[,1]<-testdata[,1] 
submission2[,2]<-as.numeric(prediction.rf)-1
for (n in 1:418){if (is.na(submission2[n,2])) 
                     submission2[n,2]<-submission[n,2]}
submission2<-as.data.frame(submission2)
names(submission2)<-c("PassengerId","Survived")
write.csv(submission2,file="submission2.csv",row.names = FALSE)
#0.65 overall score

##############################################################################################
#            Random Forest - Fist Tunning and Using coefficient of regression                #
##############################################################################################
#as the first forest has clearly not achieved a very good result, I will try to firstly tune
#the mtry parameter, then use a coefficient of regression to decrease the noise interference
#in the model. 
tune<-matrix(nrow=1000,ncol=5)
mtrydefinition<-1:5*0.5+1
tune<-as.data.frame(tune)
names(tune)<-mtrydefinition
dummy=0
for (n in mtrydefinition){
  dummy=dummy+1
  for(m in 1:1000){
    forestR<-randomForest(Survived~.,data=traindata2,mtry=n,ntree=200)
    tune[m,dummy]<-forestR$err.rate[200,1]
  }
}
# from tuning data 3 was the best parameter.
set.seed(456)
forestR2<-RRF(Survived~.,data=traindata2,mtry=3,ntree=2000,importance=T,do.trace=100, coefReg=0.8)
prediction.rf <- predict(forestR2, testdata)
submission3<-matrix(nrow=418,ncol=2)
submission3[,1]<-testdata[,1] 
submission3[,2]<-as.numeric(prediction.rf)-1
for (n in 1:418){if (is.na(submission3[n,2])) 
  submission3[n,2]<-submission[n,2]}
submission3<-as.data.frame(submission3)
names(submission3)<-c("PassengerId","Survived")
write.csv(submission3,file="submission3.csv",row.names = FALSE)
#0.63 overall score


#library(caret)
# Create model with default paramters
# control <- trainControl(method="repeatedcv", number=10, repeats=3)
# seed <- 7
# metric <- "Accuracy"
# set.seed(seed)
# mtry <- 7#sqrt(ncol(x))
# tunegrid <- expand.grid(.mtry=mtry)
# rf_default <- train(Survived~., data=traindata2, method="rf", tuneGrid=tunegrid, trControl=control)
# print(rf_default)
