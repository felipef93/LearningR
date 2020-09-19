library(stringr) #Used to transform "state name" to "State Name" if necessary
setwd("C:/Users/ACER/Desktop/R Programming/Assignment 3")
hd<-read.csv("hospital-data.csv")
od<-read.csv("outcome-of-care-measures.csv", na.strings="Not Available", stringsAsFactors=FALSE )

#Trimming data that I am going to work with
data<- cbind(od[,c(2,7,11,17,23)],(od[,c(11)]+od[,c(17)]+od[,c(23)])) #Column oveall death rate added to data
names(data)<-c("hospital","state","heart attack","heart failure","pneumonia", "overall")


#First part of the exercise: constructing a function that selects the hospital with lower mortality
# rate for a certain outcome in a given state
best<-function(state,outcome){
  #Reading and converting what was put in the script. This part was added for easier use of the function
  #It makes so that function accepts state names and abbreviations in upper or lower case
  outcome<-tolower(outcome)
  if (nchar(state)>2){
    state<-str_to_title(state)
    state<-state.abb[match(state,state.name)]
  }
  else{state<-toupper(state)}
  #checking if what was put was indeed valid
  if (!(outcome%in%names(data))){
    message("sorry my dude ain't nobody dying like that")
  }
  else{
    if(!(state%in%state.abb))
    {message("go check a geography book. There's no state with that name")}
    else{
      #Choosing best hospital of the state
      newdata<-subset(data, select=c("hospital","state",outcome)) #Subset basically select the columns of the vector that I want to work with
      newdata<- newdata[newdata[,2]%in%state,] #Selection of state
      newdata<-newdata[complete.cases(newdata),] 
      newdata<-newdata[order(newdata[outcome]),] #Ordering data
      besta<-newdata[1,] 
      return (besta[,1])
    }
  }
}

#Second part of the exercise: Similar to first function, difference is num parameter,
#that takes as input the hospital ranking.
#Accepts 'best'=1ranked and 'worst'=last ranked or n=position
rankhospital<-function(state, outcome,num='best'){
  #Reading and converting what was put in the script
  outcome<-tolower(outcome)
  if (nchar(state)>2){
    state<-str_to_title(state)
    state<-state.abb[match(state,state.name)]
  }
  else{state<-toupper(state)}
  #checking if what was put was indeed valid
  if (!(outcome%in%names(data))){
    message("sorry my dude ain't nobody dying like that")
  }
  else{
    if(!(state%in%state.abb))
    {message("go check a geography book. There's no state with that name")}
    else{
      #Choosing best hospital of the state
      newdata<-subset(data, select=c("hospital","state",outcome))
      newdata<- newdata[newdata[,2]%in%state,]
      newdata<-newdata[complete.cases(newdata),]
      newdata<-newdata[order(newdata[outcome],newdata[,1]),] #Order by outcome than by name
      if(num=='best'){
        besta<-newdata[1,]
      }
      else if(num=='worst'){
        besta<-newdata[NROW(newdata),]
      }
      else{
        besta<-newdata[num,]}
      return (besta[,1])
    }
  }
}

#Third part of the exercise: read the "num" rank mortality rate for each state for a certain "outcome"

#Function that from a data frame reads the world best and worst from num, it will also
#classify and return the n position (specified in num) of the data (auxiliary function)
readbest<-function(num, dataframe){
  dataframe<-dataframe[order(dataframe[,3],dataframe[,1]),] #order by outcome than by name
  if(num=='best'){
  besta<-dataframe[1,]
}
else if(num=='worst'){
  besta<-dataframe[NROW(dataframe),]
}
else{
  besta<-dataframe[num,]}
return(besta[,1])
  }

#Main function
rankall<-function(outcome,num='best'){
  #Reading and converting what was put in the script
  outcome<-tolower(outcome)
  #checking if what was put was indeed valid
  if (!(outcome%in%names(data))){
    message("sorry my dude ain't nobody dying like that")
  }
  else{
      #Choosing best hospital of the state
      newdata<-subset(data, select=c("hospital","state",outcome))
      newdata<-newdata[complete.cases(newdata),]
      newdata<-split(newdata,newdata[,2]) #Data was slipt according to state
      data.frame(Hospital=sapply(newdata,readbest, num=num)) # auxiliary function was sapplied in the data
  }
}
