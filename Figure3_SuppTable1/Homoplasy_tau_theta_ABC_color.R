######### Substitute the directory appropriately to read the data!

############# Set 1
setwd("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SuppTable1/Results/Set1")

library(viridis)
P <- c()
MSH <- c()
DH <- c()
P_estimate <- c()
MSH_estimate <- c()
DH_estimate <- c()
real_tau <- c()
real_theta0 <- c()
real_theta1 <- c()
tau_ABC <- c()
theta0_ABC <- c()
theta1_ABC <- c()
number_archives <- 1:100

RelativeBiasP <- c(0,0,0)
RelativeBiasMeanP <- c(0,0,0)
RelativeBiasMedianP <- c(0,0,0)

RelativeBiasDH <- c(0,0,0)
RelativeBiasMeanDH <- c(0,0,0)
RelativeBiasMedianDH <- c(0,0,0)

RelativeBiasMSH <- c(0,0,0)
RelativeBiasMeanMSH <- c(0,0,0)
RelativeBiasMedianMSH <- c(0,0,0)

Coverage50P <- c(0,0,0)
Coverage75P <- c(0,0,0)
Coverage90P <- c(0,0,0)

Coverage50MSH <- c(0,0,0)
Coverage75MSH <- c(0,0,0)
Coverage90MSH <- c(0,0,0)

Coverage50DH <- c(0,0,0)
Coverage75DH <- c(0,0,0)
Coverage90DH <- c(0,0,0)

for (i in number_archives){
	archive <- paste(i,".out",sep="")
	dat <- read.table(archive,header=T)
	print(nrow(dat))
	print (i)
	u = 5.5 *( 10^(-5))
	L=6
	Theta1= dat$T1
	N=Theta1/(2*L*u)
	tMS=dat$Time
	timeMS = tMS*2*N
	timeAR = (2*L*u)*timeMS
	d <- density(timeAR)
	tau_ABC[i] <- d$x[d$y==max(d$y)]
	real_tau[i] <- 3
	d <- density(dat$T1)
	theta1_ABC[i] <- d$x[d$y==max(d$y)]
	d <- density(dat$SASHloc)
	MSH_estimate[i] <- d$x[d$y==max(d$y)]
	d <- density(dat$SASH)
	P_estimate[i] <- d$x[d$y==max(d$y)]
	d <- density(dat$SHdist)
	DH_estimate[i] <- d$x[d$y==max(d$y)]	
	real_theta1[i] <- 30
	real_theta0[i] <- 0.03
	homoplasy_archive <- paste(i,"homoplasy.txt",sep="")
	homoplasy <- read.table(homoplasy_archive,header=T)
	MSH[i] <- homoplasy$Sizehomoplasyloc
	P[i] <- homoplasy$SASH
	DH[i] <- homoplasy$SHdist
    
    QuantilesMSH <-quantile(dat$SASHloc,probs=c(0.05,0.125,0.25,0.5,0.75,0.875,0.95))
    QuantilesDH <-quantile(dat$SHdist,probs=c(0.05,0.125,0.25,0.5,0.75,0.875,0.95))
    QuantilesP <-quantile(dat$SASH,probs=c(0.05,0.125,0.25,0.5,0.75,0.875,0.95))
    if ((P[i] >QuantilesP[3]) && (P[i] < QuantilesP[5])){
        Coverage50P[1] <- Coverage50P[1] + 1
    }
    if ((P[i] >QuantilesP[2]) && (P[i] < QuantilesP[6])){
        Coverage75P[1] <- Coverage75P[1] + 1
    }
    if ((P[i] >QuantilesP[1]) && (P[i] < QuantilesP[7])){
        Coverage90P[1] <- Coverage90P[1] + 1
    }
    
    if ((MSH[i] >QuantilesMSH[3]) && (MSH[i] < QuantilesMSH[5])){
        Coverage50MSH[1] <- Coverage50MSH[1] + 1
    }
    if ((MSH[i] >QuantilesMSH[2]) && (MSH[i] < QuantilesMSH[6])){
        Coverage75MSH[1] <- Coverage75MSH[1] + 1
    }
    if ((MSH[i] >QuantilesMSH[1]) && (MSH[i] < QuantilesMSH[7])){
        Coverage90MSH[1] <- Coverage90MSH[1] + 1
    }
    
    if ((DH[i] >QuantilesDH[3]) && (DH[i] < QuantilesDH[5])){
        Coverage50DH[1] <- Coverage50DH[1] + 1
    }
    if ((DH[i] >QuantilesDH[2]) && (DH[i] < QuantilesDH[6])){
        Coverage75DH[1] <- Coverage75DH[1] + 1
    }
    if ((DH[i] >QuantilesDH[1]) && (DH[i] < QuantilesDH[7])){
        Coverage90DH[1] <- Coverage90DH[1] + 1
    }

}


# Add colors
number <- 1:100
cols <- Colors <- viridis(10, alpha = 0.5, begin = 0, end = 1, option = "D")

color <- c()
colnum <- 1
for (i in number){
color[i] <- cols[colnum]
	if (i %% 10 == 0){
		colnum <- colnum + 1
	}
}

setwd("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SuppTable1")
pdf("Figure3.pdf",width=14,height=14)
par(mfrow=c(2,2))
par(mar=c(5,6,4,2) + 0.1)


plot(P, P_estimate, col = as.character(color),xlab="P true value", ylab= "Estimate of P", main ="A)", cex.lab = 3, cex.main = 3, cex.axis = 2, pch=19, cex=2,xlim=c(0,0.65),ylim=c(0,0.37))
#title(xlab = "P true value",cex.lab=2)
#mtext("Estimate of P", WEST <- 2, at = 0.2, line = 2, cex = 2)
Pregression <- lm (P_estimate~P)
cor(P,P_estimate)
#abline (Pregression)
summary (Pregression)
# legend ("topleft",c(expression(paste(rho," = 0.4864")),"Intercept = 0.0385","Beta = 0.3104","p-value = 2.88e-7"),bty="n", cex = 2.5)
# legend (0.04, 0.33, c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"), col = cols, title = "Tau", cex = 1.25, pch=19)
segments(0,Pregression$coefficients[1],0.65,Pregression$coefficients[1] + 0.65*Pregression$coefficients[2],lwd=2,xlim=c(0,0.65))


plot(MSH, MSH_estimate, col = as.character(color), xlab="MSH true value", ylab= "Estimate of MSH", main ="B)", cex.lab = 3, cex.main = 3, cex.axis = 2, pch=19, cex=2,xlim=c(0,0.65))
#title(xlab = "MSH true value",cex.lab=2)
#mtext("Estimate of MSH", WEST <- 2, at = 0.25, line = 2, cex = 2)
MSHregression <- lm (MSH_estimate~MSH)
cor(MSH,MSH_estimate)
#abline (MSHregression)
summary (MSHregression)
# legend ("topleft",c(expression(paste(rho," = 0.8809")),"Intercept = 0.0220","Beta = 0.8667","p-value < 2.2e-16"),bty="n", cex = 2.5)
segments(0,MSHregression$coefficients[1],0.65,MSHregression$coefficients[1] + 0.65*MSHregression$coefficients[2],lwd=2,xlim=c(0,0.65))

#legend (0.0, 0.5, c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"), col = cols, title = "Tau", cex = 1.25, pch=19)

#par(mar=c(5,6,4,10) + 0.1,xpd=TRUE)
par(mar=c(5,6,4,2) + 0.1)

plot(DH, DH_estimate, col = as.character(color),xlab="DH true value", ylab= "Estimate of DH", main ="C)", cex.lab = 3, cex.main = 3, cex.axis = 2, pch=19, cex=2,xlim=c(0,0.65))
#title(xlab = "DH true value",cex.lab=2)
#mtext("Estimate of DH", WEST <- 2, at = 0.35, line = 2, cex = 2)
DHregression <- lm (DH_estimate~DH)
cor(DH,DH_estimate)
#abline (DHregression)
summary (DHregression)
# legend ("topleft",c(expression(paste(rho," = 0.7399")),"Intercept = 0.0512","Beta = 0.8771","p-value < 2.2e-16"),bty="n", cex = 2.5)
segments(0,DHregression$coefficients[1],0.65,DHregression$coefficients[1] + 0.65*DHregression$coefficients[2],lwd=2,xlim=c(0,0.65))

#legend (.35,.15,c("Intercept = 0.0512","Beta = 0.8771","p-value < 2.2e-16"),bty="n", cex = 1.5)
# legend (0.1, 0.65, c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"), col = cols, title = "Tau", cex = 1.25, pch=19)

par(mar=c(5,6,4,2) + 0.1)
plot(1, type="n", axes=F, xlab="", ylab="")

legend("topleft",c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=19,cex=2,title=expression(tau))

dev.off()

P[P==0] <- NA
RelativeBiasP[1] <- mean((P_estimate-P)/P, na.rm=TRUE)
RelativeBiasMSH[1] <- mean((MSH_estimate-MSH)/MSH)
RelativeBiasDH[1] <- mean((DH_estimate-DH)/DH)

Matrix <- matrix(,nrow=3,ncol=3)
colnames(Matrix) <- c("0.5 coverage","0.75 coverage","0.9 coverage")
rownames(Matrix) <- c("P","MSH","DH")

Matrix[1,1] <- Coverage50P[1]/100
Matrix[1,2] <- Coverage75P[1]/100
Matrix[1,3] <- Coverage90P[1]/100
Matrix[2,1] <- Coverage50MSH[1]/100
Matrix[2,2] <- Coverage75MSH[1]/100
Matrix[2,3] <- Coverage90MSH[1]/100
Matrix[3,1] <- Coverage50DH[1]/100
Matrix[3,2] <- Coverage75DH[1]/100
Matrix[3,3] <- Coverage90DH[1]/100

write.table(Matrix, file ="SuppTable1.txt")