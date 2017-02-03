######### Substitute the directory appropriately to read the data!

############# Set 1
setwd("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SupplementaryFigure3/Results/Set1")

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

setwd("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SupplementaryFigure3")
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
legend ("topleft",c(expression(paste(rho," = 0.4864")),"Intercept = 0.0385","Beta = 0.3104","p-value = 2.88e-7"),bty="n", cex = 2.5)
# legend (0.04, 0.33, c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"), col = cols, title = "Tau", cex = 1.25, pch=19)
segments(0,Pregression$coefficients[1],0.65,Pregression$coefficients[1] + 0.65*Pregression$coefficients[2],lwd=2,xlim=c(0,0.65))


plot(MSH, MSH_estimate, col = as.character(color), xlab="MSH true value", ylab= "Estimate of MSH", main ="B)", cex.lab = 3, cex.main = 3, cex.axis = 2, pch=19, cex=2,xlim=c(0,0.65))
#title(xlab = "MSH true value",cex.lab=2)
#mtext("Estimate of MSH", WEST <- 2, at = 0.25, line = 2, cex = 2)
MSHregression <- lm (MSH_estimate~MSH)
cor(MSH,MSH_estimate)
#abline (MSHregression)
summary (MSHregression)
legend ("topleft",c(expression(paste(rho," = 0.8809")),"Intercept = 0.0220","Beta = 0.8667","p-value < 2.2e-16"),bty="n", cex = 2.5)
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
legend ("topleft",c(expression(paste(rho," = 0.7399")),"Intercept = 0.0512","Beta = 0.8771","p-value < 2.2e-16"),bty="n", cex = 2.5)
segments(0,DHregression$coefficients[1],0.65,DHregression$coefficients[1] + 0.65*DHregression$coefficients[2],lwd=2,xlim=c(0,0.65))

#legend (.35,.15,c("Intercept = 0.0512","Beta = 0.8771","p-value < 2.2e-16"),bty="n", cex = 1.5)
# legend (0.1, 0.65, c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"), col = cols, title = "Tau", cex = 1.25, pch=19)

par(mar=c(5,6,4,2) + 0.1)
plot(1, type="n", axes=F, xlab="", ylab="")

legend("topleft",c("1.5","3","4.5","6","7.5","9","10.5","12","13.5","15"),col=cols,pch=19,cex=2,title=expression(tau))

dev.off()

####### Set 2

setwd("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SupplementaryFigure3/Results/Set2")

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

for (i in number_archives){
	archive <- paste(i,".out",sep="")
	dat <- read.table(archive,header=T)
	rows <- nrow (dat)
	print (i)
	print (rows)
	print (dat$Acceptancenum[10000])
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
}

setwd("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SupplementaryFigure3")

pdf("SuppFigure3.pdf",width=21/2,height=21/2)
par(mfrow=c(3,3))
par(mar=c(5,5,4,2))
plot(MSH, MSH_estimate,xlab="MSH true value", ylab= "Estimate of MSH", main ="A) Tau = 3", cex.lab = 2.5, cex.main = 2.5, cex.axis = 1.4, pch=19, ylim=c(0,0.18), cex=2,col = Colors[10])
#title(xlab = "MSH true value",cex.lab=2)
#mtext("Estimate of MSH", WEST <- 2, at = 0.08, line = 2, cex = 2)
MSHregression <- lm (MSH_estimate~MSH)
cor(MSH,MSH_estimate)
abline (MSHregression)
summary (MSHregression)
legend ("topleft",c(expression(paste(rho," = 0.5445")),"Intercept = 0.0224","Beta = 0.5514","p-value = 4.725e-9"),bty="n", cex = 1.5)

plot(DH, DH_estimate,xlab="DH true value", ylab= "Estimate of DH", main ="B) Tau = 3", cex.lab = 2.5, cex.main = 2.5, cex.axis = 1.4, pch=19, ylim=c(0,0.35), cex=2,col = Colors[10])
#title(xlab = "DH true value",cex.lab=2)
#mtext("Estimate of DH", WEST <- 2, at = 0.18, line = 2, cex = 2)
DHregression <- lm (DH_estimate~DH)
cor(DH,DH_estimate)
abline (DHregression)
summary (DHregression)
legend ("topleft",c(expression(paste(rho," = -0.0586")),"Intercept = 0.1779","Beta = -0.0439","p-value = 0.5622"),bty="n", cex = 1.5)

plot(P, P_estimate,xlab="P true value", ylab= "Estimate of P", main ="C) Tau = 3", cex.lab = 2.5, cex.main = 2.5, cex.axis = 1.4, pch=19, ylim=c(0,0.38), cex=2,col = Colors[10])
#title(xlab = "P true value",cex.lab=2)
#mtext("Estimate of P", WEST <- 2, at = 0.18, line = 2, cex = 2)
Pregression <- lm (P_estimate~P)
cor(P,P_estimate)
abline (Pregression)
summary (Pregression)
legend ("topleft",c(expression(paste(rho," = 0.0996")),"Intercept = 0.1533","Beta = 0.0521","p-value = 0.3243"),bty="n", cex = 1.5)
# legend (.33,.28,c("Beta = 0.0521","p-value = 0.3243"),bty="n", cex = 1.5)

########### Set 3

setwd("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SupplementaryFigure3/Results/Set3")

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

for (i in number_archives){
	archive <- paste(i,".out",sep="")
	dat <- read.table(archive,header=T)
	rows <- nrow (dat)
	print (i)
	print (rows)
	print (dat$Acceptancenum[10000])
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
}

setwd("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SupplementaryFigure3")


plot(MSH, MSH_estimate,xlab="MSH true value", ylab= "Estimate of MSH", main ="D) Tau = 6", cex.lab = 2.5, cex.main = 2.5, cex.axis = 1.4, pch=19, ylim=c(0,0.4), cex=2,col = Colors[10])
#title(xlab = "MSH true value",cex.lab=2)
#mtext("Estimate of MSH", WEST <- 2, at = 0.25, line = 2, cex = 2)
MSHregression <- lm (MSH_estimate~MSH)
cor(MSH,MSH_estimate)
abline (MSHregression)
summary (MSHregression)
legend ("topleft",c(expression(paste(rho," = 0.4392")),"Intercept = 0.0883","Beta = 0.5199","p-value = 4.853e-6"),bty="n", cex = 1.5)

plot(DH, DH_estimate,xlab="DH true value", ylab= "Estimate of DH", main ="E) Tau = 6", cex.lab = 2.5, cex.main = 2.5, cex.axis = 1.4, ylim=c(0,0.55), pch=19, cex=2,col = Colors[10])
#title(xlab = "DH true value",cex.lab=2)
#mtext("Estimate of DH", WEST <- 2, at = 0.35, line = 2, cex = 2)
DHregression <- lm (DH_estimate~DH)
cor(DH,DH_estimate)
abline (DHregression)
summary (DHregression)
legend ("topright",c(expression(paste(rho," = -0.0907")),"Intercept = 0.3411","Beta = -0.0852","p-value = 0.3697"),bty="n", cex = 1.5)

plot(P, P_estimate,xlab="P true value", ylab= "Estimate of P", main ="F) Tau = 6", cex.lab = 2.5, cex.main = 2.5, cex.axis = 1.4, ylim=c(0,0.45), pch=19, cex=2,col = Colors[10])
#title(xlab = "P true value",cex.lab=2)
#mtext("Estimate of P", WEST <- 2, at = 0.18, line = 2, cex = 2)
Pregression <- lm (P_estimate~P)
cor(P,P_estimate)
abline (Pregression)
summary (Pregression)
legend ("topleft",c(expression(paste(rho," = 0.3073")),"Intercept = 0.1100","Beta = 0.1850","p-value = 0.0019"),bty="n", cex = 1.5)

####### Set 4 

setwd("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SupplementaryFigure3/Results/Set4")

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

for (i in number_archives){
	archive <- paste(i,".out",sep="")
	dat <- read.table(archive,header=T)
	rows <- nrow (dat)
	print (i)
	print (rows)
	print (dat$Acceptancenum[10000])
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
}

setwd("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SupplementaryFigure3")


plot(MSH, MSH_estimate,xlab="MSH true value", ylab= "Estimate of MSH", main ="G) Tau = 9", cex.lab = 2.5, cex.main = 2.5, cex.axis = 1.4, pch=19, ylim=c(0,0.55), cex=2,col = Colors[10])
#title(xlab = "MSH true value",cex.lab=2)
#mtext("Estimate of MSH", WEST <- 2, at = 0.3, line = 2, cex = 2)
MSHregression <- lm (MSH_estimate~MSH)
cor(MSH,MSH_estimate)
abline (MSHregression)
summary (MSHregression)
legend ("topleft",c(expression(paste(rho," = 0.3128")),"Intercept = 0.2264","Beta = 0.3357","p-value = 0.0015"),bty="n", cex = 1.5)

plot(DH, DH_estimate,xlab="DH true value", ylab= "Estimate of DH", main ="H) Tau = 9", cex.lab = 2.5, cex.main = 2.5, cex.axis = 1.4, pch=19, ylim=c(0,0.67), cex=2,col = Colors[10])
#title(xlab = "DH true value",cex.lab=2)
#mtext("Estimate of DH", WEST <- 2, at = 0.43, line = 2, cex = 2)
DHregression <- lm (DH_estimate~DH)
cor(DH,DH_estimate)
abline (DHregression)
summary (DHregression)
legend ("topleft",c(expression(paste(rho," = -0.2750")),"Intercept = 0.5362","Beta = -0.2734","p-value = 0.0056"),bty="n", cex = 1.5)

plot(P, P_estimate,xlab="P true value", ylab= "Estimate of P", main ="I) Tau = 9", cex.lab = 2.5, cex.main = 2.5, cex.axis = 1.4, pch=19, cex=2, ylim=c(0,0.24),col = Colors[10])
#title(xlab = "P true value",cex.lab=2)
#mtext("Estimate of P", WEST <- 2, at = 0.125, line = 2, cex = 2)
Pregression <- lm (P_estimate~P)
cor(P,P_estimate)
abline (Pregression)
summary (Pregression)
legend ("topleft",c(expression(paste(rho," = 0.2483")),"Intercept = 0.0504","Beta = 0.0939","p-value = 0.0127"),bty="n", cex = 1.5)

dev.off()
