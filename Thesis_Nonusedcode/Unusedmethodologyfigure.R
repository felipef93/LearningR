#Additional code from R that was not used in thesis
#This was an additional figure defining an hydrological season and dry season
library(ggplot2)

set.seed(5)

#This would have been my definition of drought season
mnt<--2:13
val<-sin(seq(-pi-5*pi/12, pi+pi/12, length.out = 16))
val[4:15]<-val[4:15]+rnorm(12,0,sd=0.2)
label<-c(month.abb,month.abb[1:4])
ggplot()+geom_line(aes(x=mnt,y=val))+scale_x_continuous(name = "Month", breaks = -2:13, labels = label)+ylab('Water Balance')

#This is carachterising one water year
val2<-sin(seq(-5*pi/24, pi+pi/24, length.out = 16))^2
val2[4:15]<-val2[4:15]+rnorm(12,0,sd=0.2)
label2<-c(month.abb[6:12],month.abb[1:9])
ggplot()+geom_line(aes(x=mnt,y=val2))+scale_x_continuous(name = "Month", breaks = -2:13, labels = label2)+ylab('Runoff')
