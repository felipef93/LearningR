#Function to transform caracter and factor data to numeric data
transformnumeric<-function(dataset,colnbr){
  b<-names(table(dataset[[colnbr]]))
  m<-0
  for (n in b){
    dataset[[colnbr]][dataset[[colnbr]]==n]<-m
    m<-m+1
  }
  dataset[[colnbr]]<-as.numeric(dataset[[colnbr]])
  return(dataset)
}
