#Intstalar os pacotes (somente necessario na primeira utilizacao)
#install.packages("stringr")
#install.packages("ggplot2")

#Call packages
library(stringr)
library(ggplot2)
library(extRemes)

#Input de dados
setwd("C:/Users/ACER/Desktop/Brevipalpus/") #Local do arquivo
dused<-read.csv('data2.csv',sep =';') #Nome do arquivo
standarderr =1.96 #Erro considerado aqui 1.96 = 95%

acaros<-c( # Nomes dos acaros
          'californicus[-_]1','californicus[-_]2','californicus[-_]ss',
          'cuneatus[-_]1','cuneatus[-_]2',
          'chilensis', 'ferraguti',
          'incognitus(?!-|_)','incognitus[-_]1','incognitus[-_]2',
          'lewisi','B[-_]nsp','obovatus', 
          'oleae','phoenicis','papayensis',
          'yothersi(?!-)','yothersi[-_]1','yothersi[-_]2',
          #Nomes dos grupos
          'OBOVATUS','YOTHERSI','CALIFORNICUS','OLEAE',
          'CUNEATUS', 'nso',
          # Outros
          'C_pulcher','Cenopalpus','outgroup'
          )

#Nomes dos acaros presentes no arquivo

###################################################################################################
###################################################################################################
###################################################################################################
###################################################################################################
###################################################################################################
#Programa
#Simplificacao dos numeros da tabela para nomes de acaros
for(n in 1:nrow(dused)){
  identifypattern1<-str_match(dused[n,1],acaros)%>%na.omit()
  identifypattern2<-str_match(dused[n,2],acaros)%>%na.omit()
  if(length(identifypattern1)>0&length(identifypattern2)>0){
    dused[n,1]<-str_extract(dused[n,1],identifypattern1)
    dused[n,2]<-str_extract(dused[n,2],identifypattern2) 
  }
}
#Limpeza de dados e calculo de errros
logicalexclusion<-!(dused[,1]%in% c('outgroup','Cenopalpus','C_pulcher')|
                      dused[,2]%in% c('outgroup','Cenopalpus','C_pulcher')) 
dclean<-dused[complete.cases(dused),]
dclean<-dclean[logicalexclusion,]
for (n in 3:4) dclean[,n]<-as.numeric(dclean[,n])
dclean[4]<-dclean[4]*standarderr
firstcol<-names(table(dclean[1]))
secondcol<-names(table(dclean[2]))
#Dados separados entre mesma comparacao entre mesmas especies (datamin)
#e comparacao entre especies differentes (datamax)
datamax<-data.frame()
datamin<-data.frame()
x<-0
for (n in firstcol){
  logi1<-dclean[,1]==n
  for (m in secondcol){
    logi2<-dclean[,2]==m
    x<-x+1
    if (n==m) {
      datamax[x,1]=n
      datamax[x,2:3]<-sapply(dclean[logi1 & logi2,3:4],max)}
      else {
        datamin[x,1]=n
        datamin[x,2]=m
        datamin[x,3:4]<-sapply(dclean[logi1 & logi2,3:4],min)}
  }
}
names(datamax)<-c('Species','Value','error')
names(datamin)<-c('Species1','Species2','Value','error')
#Remocao de dados inexistentes (comparacao entre mesmas especiens em datamax e vice-versa) )
datamax<-datamax[complete.cases(datamax),]
datamax<-datamax[datamax[2]!=-Inf,]
datamax<-datamax[order(datamax$Value),]
datamin<-datamin[complete.cases(datamin),]
datamin<-datamin[datamin[3]!=Inf,]
datamin<-datamin[order(datamin$Value,decreasing = T),]

#Preparacao dos valores a serem plotados
plotvalmax<-matrix(ncol=5,nrow=nrow(datamax))
plotvalmin<-matrix(ncol=6,nrow=nrow(datamin))
plotvalmax[,1]<-c(1:nrow(datamax)/nrow(datamax))
plotvalmax[,2]<-datamax[,2]
plotvalmax[,3]<-datamax[,2]-datamax[,3]
for (n in 1:nrow(plotvalmax)) if(plotvalmax[n,3]<0) plotvalmax[n,3]<-0
plotvalmax[,4]<-datamax[,2]+datamax[,3]
plotvalmax[,5]<-datamax[,1]
plotvalmax<-as.data.frame(plotvalmax)
for (n in 1:4) plotvalmax[,n]<-as.numeric(plotvalmax[,n])
names(plotvalmax)<-c("Cumdist","Meany","Miny","Maxy","Name")

plotvalmin[,1]<-c(1:nrow(datamin)/nrow(datamin))
plotvalmin[,2]<-datamin[,3]
plotvalmin[,3]<-datamin[,3]-datamin[,4]
for (n in 1:nrow(plotvalmin)) if(plotvalmin[n,3]<0) plotvalmin[n,3]<-0
plotvalmin[,4]<-datamin[,3]+datamin[,4]
plotvalmin[,5]<-datamin[,1]
plotvalmin[,6]<-datamin[,2]
plotvalmin<-as.data.frame(plotvalmin)
for (n in 1:4) plotvalmin[,n]<-as.numeric(plotvalmin[,n])
names(plotvalmin)<-c("Cumdist","Meany","Miny","Maxy","Name1","Names2")

###################################################################################################
###################################################################################################
#Output

#Plot
ggplot()+geom_point(data=plotvalmax,aes(x=Cumdist,y=Meany,col='red'))+
  geom_smooth(data=plotvalmax,aes(x=Cumdist,y=Meany,col='red'),method='loess',formula=y~x,se=F)+
  geom_smooth(data=plotvalmax,aes(x=Cumdist,y=Miny,col='red'),method='loess',formula=y~x,se=F, linetype='dashed')+
  geom_smooth(data=plotvalmax,aes(x=Cumdist,y=Maxy,col='red'),method='loess',formula=y~x,se=F,linetype='dashed')+
  geom_point(data=plotvalmin,aes(x=Cumdist,y=Meany,col='blue'))+
  geom_smooth(data=plotvalmin,aes(x=Cumdist,y=Meany,col='blue'),method='loess',formula=y~x,se=F)+
  geom_smooth(data=plotvalmin,aes(x=Cumdist,y=Miny,col='blue'),method='loess',formula=y~x,se=F,linetype='dashed')+
  geom_smooth(data=plotvalmin,aes(x=Cumdist,y=Maxy,col='blue'),method='loess',formula=y~x,se=F,linetype='dashed')

#Interseccao
#Aqui voce escolhe o ponto que voce quer representar
#O codigo e o seguinte: meany em inter1 e meany em inter2 = media
# Maxy em inter 1 e Miny em inter 2 scenario mais rigoroso possivel
# Miny em inter 1 e Maxy em inter 2 scenario menos rigoroso possivel
inter1<-loess(Maxy~Cumdist,plotvalmax)
inter2<-loess(Miny~Cumdist,plotvalmin)
intersecting <- optimize(function(x, m1, m2) (predict(m1, x) - predict(m2, x))^2,
                         0:1, inter1, inter2)  

message(paste('O ponto aproximado de interseccao das curvas e',
              (predict(inter2,intersecting$minimum)+predict(inter1,intersecting$minimum))/2))

#Tipos de especies
speciesdiffbellowthreshold<-plotvalmin[round(inter2$x-intersecting$minimum,digits=3)>0,]
speciessameabovetreshold<-plotvalmax[round(inter1$x-intersecting$minimum,digits=3)>0,]

#Extreme values
returnspecies<-fevd(plotvalmax$Meany,method='Lmoments',type='GEV')
plot(returnspecies, type='rl',rperiods = c(2,10,20,50,100,200,292))
returnperiod<-return.level(returnspecies, conf = 0.05, return.period= c(2, 5, 10, 20, 50,100,200,292))

dbaseforsamplesize <-data.frame()
x<-0
for (n in 1:nrow(dclean)){
          if(dclean[n,1]!=dclean[n,2]){
                x<-x+1
                dbaseforsamplesize[x,1:4]<-dclean[n,1:4]
                }
}
nbrpairs<-fevd(x=1/dbaseforsamplesize$Dist,threshold = 1/0.03,method='Lmoments',type='GP',span=136, time.units="years")
plot(nbrpairs, type='rl',rperiods = c(50,100,500,1000,5000,10000,20000,42486))
#why 42486 -> 292!/(290!*2!) -> 292*291/2
nbrpairsperiod<-return.level(nbrpairs, conf = 0.05, return.period= c(50,100,500,1000,5000,10000,20000,42486))
