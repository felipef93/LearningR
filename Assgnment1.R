#This file contains functions corresponding to exercises of 
# Week 2 in the R programming online course by Johns Hopkins University 

setwd("C:/Users/ACER/Desktop/R Programming/") #my working directory

# Exercise 1:
# Function pollutantmean calculates the mean value of a column("pollutant") inside csv documents
# ("id") for a directory of you choice(dir)

pollutantmean<-function(dir="",pollutant,id){
  file_n<-list.files(dir) # list the name of the files in the directory
  newdata<-data.frame() #creation of empty data frame to store values of for loop
  for (i in id){
        newdata<-rbind(newdata,read.csv(paste(dir,file_n[i], sep="/"))) # New dataframe containing
        #all the data of imported .csv files
        meanpol<-colMeans(newdata[pollutant],na.rm=TRUE) #mean of selected column in the created df
  }
  meanpol # return the mean values
}

#Exercise 2:
#Function completedata counts the number of complete cases in csv files("id") 
#located in directory "dir"

completedata<-function(dir="",id=1:322){
  file_n<-list.files(dir) 
  poldata<-data.frame()
  completevalues<-NA #creation of vector to store values in the for loop
  for(i in id){
    poldata<-read.csv(paste(dir,file_n[i], sep="/")) #Note that without rbind, data will be read in
    #the for loop
    npdata<-NROW(poldata[complete.cases(poldata),]) #Counts the number of complete rows in the 
    #different csv files
    completevalues[i]<-npdata #gets number of complete values inside completevalues vector
  }
  identify<- completevalues[id] # associates complete values with respective id
  exit<-data.frame(id=id,nbrvalues=identify) 
  return (exit)
}  

#Exercise 3:
#Function corr calculates the correlation between two variables inside csv
#files located in a directory ("dir"), with a number of complete cases above
#a defined threshold ("treshold")

corr<-function(dir="",treshold=0){
  nbrvalues<- completedata(dir)$nbrvalues #use of previous function to find nbr of values in each file
  file_n<-list.files(dir)
  lengthvector<-length(nbrvalues) #Number of files in the directory
  newdata<-data.frame()
  corrvalues<-matrix(nrow=lengthvector,ncol=2) # creation of matrix to store id(c1) and correlation (c2)
  for(i in 1:lengthvector){
    if(nbrvalues[i]>treshold){ 
      newdata<-read.csv(paste(dir,file_n[i], sep="/"))
      relationship<-cor(newdata$sulfate,newdata$nitrate,use="complete.obs") #if value above threshold
      #correlation is calculated
      corrvalues[i,]<-c(i,relationship) # and matrix is filled with(id,cor)
    }else{corrvalues[i,]<-c(i,NA)}#else value in matrtix (id,NA)
  }
  return (corrvalues)
}

#Examples:
print("Examples ex 1:")
print("Sulfate c for the first 10 csv files") 
      pollutantmean("specdata", "sulfate", 1:10)
print("Nitrate c for the 70 to 72th csv files")
      pollutantmean("specdata", "nitrate", 70:72)

print("Examples ex 2:")
print("Number of values for csv files nbr 2,4,8,10,12:")
      completedata("specdata", c(2, 4, 8, 10, 12))
print("Number of values for csv files from 30th to 25th:")
      completedata("specdata", 30:25)

print("Examples ex 3:")
cr <- corr("specdata", 150)
print("Summary of correlations beetween nitrate and sulfate 
      for files with more than 150 values: ")
      summary(cr)
cr <- corr("specdata", 400)
print("Summary of correlations beetween nitrate and sulfate 
      for files with more than 400 values: ")
      summary(cr)