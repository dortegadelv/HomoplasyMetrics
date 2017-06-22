setwd("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure2_SupplementaryFigure1")
library(viridis)
Colors <- viridis(10, alpha = 0.5, begin = 0, end = 1, option = "D")

AllSum <- read.table ("OutputTotalSum.txt")
WeirdSFS <- read.table ("SimsToCheck/SFSInfinite_Case55.txt")
RandomSFS1 <- read.table ("SimsToCheck/SFSInfinite_Case1.txt")
RandomSFS2 <- read.table ("SimsToCheck/SFSInfinite_Case2.txt")

AllSum$V2 <- AllSum$V2 / sum(AllSum$V2)
WeirdSFS$V2 <- WeirdSFS$V2 / sum(WeirdSFS$V2)
RandomSFS1$V2 <- RandomSFS1$V2 / sum(RandomSFS1$V2)
RandomSFS2$V2 <- RandomSFS2$V2 / sum(RandomSFS2$V2)

pdf("SuppFigureS1.pdf",width=9)
par(mfrow=c(2,3))
par(mar=c(5,6,4,1) + 0.1)

plot(AllSum$V2,ylim=c(0,0.11),xlim=c(0,40),xlab="Number of pairwise differences",ylab="Frequency",type="o", main = "A)",pch=19, cex.main = 3,cex.axis =2, cex.lab=1.3)
lines(WeirdSFS$V2,col = "red",type="o",pch=3)
lines(RandomSFS1$V2,col = "blue",type="o",pch=4)
lines(RandomSFS2$V2,col = "green",type="o",pch=2)
legend("topright",c("All sims average","Multimodal sim","Random sim 1","Random sim 2"),lty=1,col=c("black","red","blue","green"),pch=c(19,3,4,2),cex=0.8)

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
par(mar=c(5,6,4,1) + 0.1)
boxplot(data$IS_tau[901:1000], ylab=expression(tau), cex.main = 3, main="B)",cex.lab=3, cex.axis = 2)
Mean <- mean(data$IS_tau[901:1000])
Median <- median(data$IS_tau[901:1000])
abline(h=15,lty="dashed")

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

# par(mfrow = c(2,2))
par(mar=c(5,6,4,1) + 0.1)
plot (data$P,data$diference,col=as.character(data$color) ,xlab="",ylab="TS",main="C)",cex.lab = 3, cex.main = 3.0,cex.axis = 2,xlim=c(0,0.65),yaxt="n",pch=19, cex=2)
cor(data$P,data$diference) ## it is -0.1351
axis(2,cex.axis=2)
title (xlab="P", cex.lab=3)
#mtext ("Tau skew ",WEST <-2, at = 0, line = 2, cex = 2)
Pregression <- lm(data$diference~data$P)
segments(0,Pregression$coefficients[1],0.65,Pregression$coefficients[1] + 0.65*Pregression$coefficients[2],col="red",lwd=2)
#legend(0.5,.125,c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=1,cex=1.25,title="Tau")
summary(Pregression)
legend("center",c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=19,cex=1,title=expression(tau))

#legend(0.3,-.25,c(expression(paste(rho," = -0.1351")),"Intercept = 0.3812","Beta = -0.2323","p-value = 1.9e-5"),cex=2,bty="n")

par(mar=c(5,6,4,1) + 0.1)
plot (data$MSH,data$diference,col=as.character(data$color),xlab = "",ylab="TS",main="D)",cex.lab = 3, cex.main = 3.0,cex.axis = 2,xlim=c(0,0.65),yaxt="n",pch=19, cex=2)
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
par(mar=c(5,6,4,1) + 0.1)

plot (data$DH,data$diference,col=as.character(data$color),xlab="",ylab="TS",main="E)",cex.lab = 3, cex.main = 3.0,cex.axis = 2,xlim=c(0,0.65),yaxt="n",pch=19, cex=2)
cor(data$DH,data$diference) ## it is 0.7920
axis(2,cex.axis=2)
title (xlab="DH", cex.lab=3)
#mtext ("Tau skew ",WEST <-2, at = 0, line = 2, cex = 2)
DHregression <- lm(data$diference~data$DH)
segments(0,DHregression$coefficients[1],0.65,DHregression$coefficients[1] + 0.65*DHregression$coefficients[2],col="red",lwd=2,xlim=c(0,0.65))

summary(DHregression)
#legend(0.3,-.26,c(expression(paste(rho," = 0.7920")),"Intercept = -0.0466","Beta = 1.1370","p-value < 2.2e-16"),cex=2,bty="n")

# par(mar=c(5,6,4,2) + 0.1)
# plot(1, type="n", axes=F, xlab="", ylab="")

# legend("topleft",c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=19,cex=1.5,title=expression(tau))

dev.off()

Mean <- sum (WeirdSFS$V1 * WeirdSFS$V2)
MeanSq <- sum (WeirdSFS$V1 * WeirdSFS$V1 * WeirdSFS$V2)
Var <- MeanSq - Mean * Mean
Theta0 <- (Var - Mean)^(1/2)
Tau = Mean - Theta0
