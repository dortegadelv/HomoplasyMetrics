######### Substitute the directory appropriately to read the data!

# setwd("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/SupplementaryFigure2")
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
color[i] <- cols[colnum]
if((i %% 100) == 0){
colnum <- colnum+1
}
}

data <- cbind(data,color)

test <- subset (data,data$diference< -1)
data <- subset (data,data$diference>=-1)

pdf("SuppFig2.pdf",height=14,width=14)
par(mfrow = c(2,2))

par(mar=c(5,6,4,2) + 0.1)
plot (data$P,data$diference,col=as.character(data$color) ,xlab="",ylab="Tau skew",main="A)",cex.lab = 3, cex.main = 3.0,cex.axis = 2,xlim=c(0,0.65),yaxt="n",pch=19)
cor(data$P,data$diference) ## it is -0.1351
axis(2, at = c(-0.5,0,0.5),cex.axis=2)
title (xlab="P", cex.lab=3)
#mtext ("Tau skew ",WEST <-2, at = 0, line = 2, cex = 2)
Pregression <- lm(data$diference~data$P)
segments(0,Pregression$coefficients[1],0.65,Pregression$coefficients[1] + 0.65*Pregression$coefficients[2],col="red",lwd=2)
#legend(0.5,.125,c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=1,cex=1.25,title="Tau")
summary(Pregression)
legend(0.2,-.05,c(expression(paste(rho," = -0.2617")),"Intercept = 0.4137","Beta = -0.3412","p-value < 2.2e-16"),cex=2.5,bty="n")

par(mar=c(5,6,4,2) + 0.1)
plot (data$MSH,data$diference,col=as.character(data$color),xlab = "",ylab="Tau skew",main="B)",cex.lab = 3, cex.main = 3.0,cex.axis = 2,xlim=c(0,0.65),yaxt="n",pch=19)
cor(data$MSH,data$diference) ## it is 0.7658
axis(2, at = c(-0.5,0,0.5),cex.axis=2)
title (xlab="MSH", cex.lab=3)
#mtext ("Tau skew ",WEST <-2, at = 0, line = 2, cex = 2)
MSHregression <- lm(data$diference~data$MSH)
segments(0,MSHregression$coefficients[1],0.65,MSHregression$coefficients[1] + 0.65*MSHregression$coefficients[2],col="red",lwd=2)
#legend(0.5,0.25,c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=1,cex=1.25,title="Tau")
summary(MSHregression)
legend(0.2 ,-.05,c(expression(paste(rho," = 0.8673")),"Intercept = 0.1109","Beta = 0.7829","p-value < 2.2e-16"),cex=2.5,bty="n")

# par(mar=c(5,6,4,10) + 0.1,xpd=TRUE)
par(mar=c(5,6,4,2) + 0.1)

plot (data$DH,data$diference,col=as.character(data$color),xlab="",ylab="Tau skew",main="C)",cex.lab = 3, cex.main = 3.0,cex.axis = 2,xlim=c(0,0.65),yaxt="n",pch=19)
cor(data$DH,data$diference) ## it is 0.7920
axis(2, at = c(-0.5,0,0.5),cex.axis=2)
title (xlab="DH", cex.lab=3)
#mtext ("Tau skew ",WEST <-2, at = 0, line = 2, cex = 2)
DHregression <- lm(data$diference~data$DH)
segments(0,DHregression$coefficients[1],0.65,DHregression$coefficients[1] + 0.65*DHregression$coefficients[2],col="red",lwd=2,xlim=c(0,0.65))
#legend("topright",inset=c(-0.1,0),c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=19,cex=2,title=expression(tau))
summary(DHregression)
legend(0.2,-.05,c(expression(paste(rho," = 0.8777")),"Intercept = -0.0558","Beta = 1.1309","p-value < 2.2e-16"),cex=2.5,bty="n")

par(mar=c(5,6,4,2) + 0.1)
plot(1, type="n", axes=F, xlab="", ylab="")

legend("topleft",c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=19,cex=2,title=expression(tau))

dev.off()

cor.test(data$DH,data$MSH) ## It is 0.9211
cor.test(data$DH,data$P) ## It is 0.9211
cor.test(data$P,data$MSH) ## It is 0.9211
