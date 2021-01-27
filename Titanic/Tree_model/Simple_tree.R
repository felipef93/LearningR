library(rpart)
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
plotcp(testtree) #Plot of Cp
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
names(submission)<-c("PassengerId","Survived")#An given correct names

write.csv(submission,file="submission.csv",row.names = FALSE) #Export as csv file
#This model has accuracy 0.77990
