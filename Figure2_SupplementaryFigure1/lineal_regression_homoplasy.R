######### Substitute the directory appropriately to read the data!

setwd("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure2_SupplementaryFigure1")
require(car)
library(viridis)
Colors <- viridis(10, alpha = 0.5, begin = 0, end = 1, option = "D")
data <- read.table("homoplasy_tau.txt",header=T)
diference <- (data$IS_tau - data$tau)/data$IS_tau
data <- cbind(data,diference)
number <- 1:1000
data <- cbind (data,number)
colnum <-1
cols<-Colors
color <- c()
for (i in number){
color <- c(color,cols[colnum])
if((i %% 100) == 0){
colnum <- colnum+1
}
}

data <- cbind(data,color)

test <- subset (data,data$diference< -1)
data <- subset (data,data$diference>=-1)

#pdf("Figure1.pdf",width=36)
pdf("Figure2_ThingsBiggerThanMinusOne.pdf",height=14,width=14)
par(mfrow = c(2,2))

par(mar=c(5,6,4,2) + 0.1)
plot (data$P,data$diference,col=as.character(data$color) ,xlab="",ylab="TS",main="A)",cex.lab = 3, cex.main = 3.0,cex.axis = 2,xlim=c(0,0.65),yaxt="n",pch=19, cex=2)
cor(data$P,data$diference) ## it is -0.1351
axis(2, at = c(-0.5,0,0.5),cex.axis=2)
title (xlab="P", cex.lab=3)
#mtext ("Tau skew ",WEST <-2, at = 0, line = 2, cex = 2)
Pregression <- lm(data$diference~data$P)
segments(0,Pregression$coefficients[1],0.65,Pregression$coefficients[1] + 0.65*Pregression$coefficients[2],col="red",lwd=2)
#legend(0.5,.125,c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=1,cex=1.25,title="Tau")
summary(Pregression)
legend(0.3,-.25,c(expression(paste(rho," = -0.1351")),"Intercept = 0.3812","Beta = -0.2323","p-value = 1.9e-5"),cex=2,bty="n")

par(mar=c(5,6,4,2) + 0.1)
plot (data$MSH,data$diference,col=as.character(data$color),xlab = "",ylab="TS",main="B)",cex.lab = 3, cex.main = 3.0,cex.axis = 2,xlim=c(0,0.65),yaxt="n",pch=19, cex=2)
cor(data$MSH,data$diference) ## it is 0.7658
axis(2, at = c(-0.5,0,0.5),cex.axis=2)
title (xlab="MSH", cex.lab=3)
#mtext ("Tau skew ",WEST <-2, at = 0, line = 2, cex = 2)
MSHregression <- lm(data$diference~data$MSH)
segments(0,MSHregression$coefficients[1],0.65,MSHregression$coefficients[1] + 0.65*MSHregression$coefficients[2],col="red",lwd=2)
#legend(0.5,0.25,c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=1,cex=1.25,title="Tau")
summary(MSHregression)
legend(0.3 ,-.25,c(expression(paste(rho," = 0.7658")),"Intercept = 0.1011","Beta = 0.9620","p-value < 2.2e-16"),cex=2,bty="n")

#par(mar=c(5,6,4,10) + 0.1,xpd=TRUE)
par(mar=c(5,6,4,2) + 0.1)

plot (data$DH,data$diference,col=as.character(data$color),xlab="",ylab="TS",main="C)",cex.lab = 3, cex.main = 3.0,cex.axis = 2,xlim=c(0,0.65),yaxt="n",pch=19, cex=2)
cor(data$DH,data$diference) ## it is 0.7920
axis(2, at = c(-0.5,0,0.5),cex.axis=2)
title (xlab="DH", cex.lab=3)
#mtext ("Tau skew ",WEST <-2, at = 0, line = 2, cex = 2)
DHregression <- lm(data$diference~data$DH)
segments(0,DHregression$coefficients[1],0.65,DHregression$coefficients[1] + 0.65*DHregression$coefficients[2],col="red",lwd=2,xlim=c(0,0.65))

summary(DHregression)
legend(0.3,-.26,c(expression(paste(rho," = 0.7920")),"Intercept = -0.0466","Beta = 1.1370","p-value < 2.2e-16"),cex=2,bty="n")

par(mar=c(5,6,4,2) + 0.1)
plot(1, type="n", axes=F, xlab="", ylab="")

legend("topleft",c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=19,cex=2,title=expression(tau))

dev.off()

cor.test(data$DH,data$MSH) ## It is 0.9211
cor.test(data$DH,data$P) ## It is -0.0992
cor.test(data$P,data$MSH) ## It is -0.2696


######### Alternative Figure with all the data

data <- read.table("homoplasy_tau.txt",header=T)
pdf("Figure2_AllData.pdf",height=14,width=14)

require(car)
library(viridis)
Colors <- viridis(10, alpha = 0.5, begin = 0, end = 1, option = "D")
data <- read.table("homoplasy_tau.txt",header=T)
diference <- (data$IS_tau - data$tau)/data$IS_tau
data <- cbind(data,diference)
number <- 1:1000
data <- cbind (data,number)
colnum <-1
cols<-Colors
color <- c()
for (i in number){
    color <- c(color,cols[colnum])
    if((i %% 100) == 0){
        colnum <- colnum+1
    }
}

data <- cbind(data,color)
# data <- subset (data,data$diference>=-10)

par(mfrow = c(2,2))
par(mar=c(5,6,4,2) + 0.1)
plot (data$P,data$diference,col=as.character(data$color) ,xlab="",ylab="TS",main="A)",cex.lab = 3, cex.main = 3.0,cex.axis = 2,xlim=c(0,0.65),yaxt="n",pch=19, cex=2)
cor(data$P,data$diference) ## it is -0.1351
axis(2,cex.axis=2)
title (xlab="P", cex.lab=3)
#mtext ("Tau skew ",WEST <-2, at = 0, line = 2, cex = 2)
Pregression <- lm(data$diference~data$P)
segments(0,Pregression$coefficients[1],0.65,Pregression$coefficients[1] + 0.65*Pregression$coefficients[2],col="red",lwd=2)
#legend(0.5,.125,c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=1,cex=1.25,title="Tau")
summary(Pregression)
#legend(0.3,-.25,c(expression(paste(rho," = -0.1351")),"Intercept = 0.3812","Beta = -0.2323","p-value = 1.9e-5"),cex=2,bty="n")

par(mar=c(5,6,4,2) + 0.1)
plot (data$MSH,data$diference,col=as.character(data$color),xlab = "",ylab="TS",main="B)",cex.lab = 3, cex.main = 3.0,cex.axis = 2,xlim=c(0,0.65),yaxt="n",pch=19, cex=2)
cor(data$MSH,data$diference) ## it is 0.7658
axis(2,cex.axis=2)
title (xlab="MSH", cex.lab=3)
#mtext ("Tau skew ",WEST <-2, at = 0, line = 2, cex = 2)
MSHregression <- lm(data$diference~data$MSH)
segments(0,MSHregression$coefficients[1],0.65,MSHregression$coefficients[1] + 0.65*MSHregression$coefficients[2],col="red",lwd=2)
#legend(0.5,0.25,c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=1,cex=1.25,title="Tau")
summary(MSHregression)
#legend(0.3 ,-.25,c(expression(paste(rho," = 0.7658")),"Intercept = 0.1011","Beta = 0.9620","p-value < 2.2e-16"),cex=2,bty="n")

#par(mar=c(5,6,4,10) + 0.1,xpd=TRUE)
par(mar=c(5,6,4,2) + 0.1)

plot (data$DH,data$diference,col=as.character(data$color),xlab="",ylab="TS",main="C)",cex.lab = 3, cex.main = 3.0,cex.axis = 2,xlim=c(0,0.65),yaxt="n",pch=19, cex=2)
cor(data$DH,data$diference) ## it is 0.7920
axis(2,cex.axis=2)
title (xlab="DH", cex.lab=3)
#mtext ("Tau skew ",WEST <-2, at = 0, line = 2, cex = 2)
DHregression <- lm(data$diference~data$DH)
segments(0,DHregression$coefficients[1],0.65,DHregression$coefficients[1] + 0.65*DHregression$coefficients[2],col="red",lwd=2,xlim=c(0,0.65))

summary(DHregression)
#legend(0.3,-.26,c(expression(paste(rho," = 0.7920")),"Intercept = -0.0466","Beta = 1.1370","p-value < 2.2e-16"),cex=2,bty="n")

par(mar=c(5,6,4,2) + 0.1)
plot(1, type="n", axes=F, xlab="", ylab="")

legend("topleft",c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=19,cex=2,title=expression(tau))

dev.off()

cor.test(data$DH,data$MSH) ## It is 0.9211
cor.test(data$DH,data$P) ## It is -0.0992
cor.test(data$P,data$MSH) ## It is -0.2696

#### Data bigger than -10

######### Alternative Figure with all the data

data <- read.table("homoplasy_tau.txt",header=T)
pdf("Figure2.pdf",height=14,width=14)

require(car)
library(viridis)
Colors <- viridis(10, alpha = 0.5, begin = 0, end = 1, option = "D")
data <- read.table("homoplasy_tau.txt",header=T)
diference <- (data$IS_tau - data$tau)/data$IS_tau
data <- cbind(data,diference)
number <- 1:1000
data <- cbind (data,number)
colnum <-1
cols<-Colors
color <- c()
for (i in number){
    color <- c(color,cols[colnum])
    if((i %% 100) == 0){
        colnum <- colnum+1
    }
}

data <- cbind(data,color)
test <- subset (data,data$diference<=-10)
data <- subset (data,data$diference>=-10)

par(mfrow = c(2,2))
par(mar=c(5,6,4,2) + 0.1)
plot (data$P,data$diference,col=as.character(data$color) ,xlab="",ylab="TS",main="A)",cex.lab = 3, cex.main = 3.0,cex.axis = 2,xlim=c(0,0.65),yaxt="n",pch=19, cex=2)
cor(data$P,data$diference) ## it is -0.1351
axis(2,cex.axis=2)
title (xlab="P", cex.lab=3)
#mtext ("Tau skew ",WEST <-2, at = 0, line = 2, cex = 2)
Pregression <- lm(data$diference~data$P)
segments(0,Pregression$coefficients[1],0.65,Pregression$coefficients[1] + 0.65*Pregression$coefficients[2],col="red",lwd=2)
#legend(0.5,.125,c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=1,cex=1.25,title="Tau")
summary(Pregression)
#legend(0.3,-.25,c(expression(paste(rho," = -0.1351")),"Intercept = 0.3812","Beta = -0.2323","p-value = 1.9e-5"),cex=2,bty="n")

par(mar=c(5,6,4,2) + 0.1)
plot (data$MSH,data$diference,col=as.character(data$color),xlab = "",ylab="TS",main="B)",cex.lab = 3, cex.main = 3.0,cex.axis = 2,xlim=c(0,0.65),yaxt="n",pch=19, cex=2)
cor(data$MSH,data$diference) ## it is 0.7658
axis(2,cex.axis=2)
title (xlab="MSH", cex.lab=3)
#mtext ("Tau skew ",WEST <-2, at = 0, line = 2, cex = 2)
MSHregression <- lm(data$diference~data$MSH)
segments(0,MSHregression$coefficients[1],0.65,MSHregression$coefficients[1] + 0.65*MSHregression$coefficients[2],col="red",lwd=2)
#legend(0.5,0.25,c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=1,cex=1.25,title="Tau")
summary(MSHregression)
#legend(0.3 ,-.25,c(expression(paste(rho," = 0.6903")),"Intercept = 0.0893","Beta = 0.9868","p-value < 2.2e-16"),cex=2,bty="n")

#par(mar=c(5,6,4,10) + 0.1,xpd=TRUE)
par(mar=c(5,6,4,2) + 0.1)

plot (data$DH,data$diference,col=as.character(data$color),xlab="",ylab="TS",main="C)",cex.lab = 3, cex.main = 3.0,cex.axis = 2,xlim=c(0,0.65),yaxt="n",pch=19, cex=2)
cor(data$DH,data$diference) ## it is 0.7920
axis(2,cex.axis=2)
title (xlab="DH", cex.lab=3)
#mtext ("Tau skew ",WEST <-2, at = 0, line = 2, cex = 2)
DHregression <- lm(data$diference~data$DH)
segments(0,DHregression$coefficients[1],0.65,DHregression$coefficients[1] + 0.65*DHregression$coefficients[2],col="red",lwd=2,xlim=c(0,0.65))

summary(DHregression)
#legend(0.3,-.26,c(expression(paste(rho," = 0.6989")),"Intercept = -0.0541","Beta = 1.1424","p-value < 2.2e-16"),cex=2,bty="n")

par(mar=c(5,6,4,2) + 0.1)
plot(1, type="n", axes=F, xlab="", ylab="")

legend("topleft",c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=19,cex=2,title=expression(tau))

dev.off()

cor.test(data$DH,data$MSH) ## It is 0.9208
cor.test(data$DH,data$P) ## It is -0.0976
cor.test(data$P,data$MSH) ## It is -0.2685
