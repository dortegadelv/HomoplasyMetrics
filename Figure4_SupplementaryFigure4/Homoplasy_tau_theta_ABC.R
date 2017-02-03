######### Substitute the directory appropriately to read the data!
### Make the Directory vector point to the direction of the results from the Figure3_SupplementaryFigure3 folder

Directory <- c("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SupplementaryFigure3/Results/Set2/","/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SupplementaryFigure3/Results/Set3/","/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SupplementaryFigure3/Results/Set4/")

#Title <- c(expression(paste("A) ",tau," = 3")), expression(paste("B) ",tau," = 6")), expression(paste("C) ",tau," = 9")))
Title <- c("A)","B)","C)")
YLab <- c("Tau (real value = 3)","Tau (real value = 6)","Tau (real value = 9)")

AbLinePlace <- c(3,6,9)

pdf("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure4_SupplementaryFigure4/Figure4.pdf",width=21/2,height=3.5)
par(mfrow=c(1,3), mar=c(5,6,4,2))

require("beanplot")

for (j in 1:3){
	
setwd(Directory[j])
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

Navascues_data <- read.table("tauNavascues.txt")
tau_Navascues <- Navascues_data[,3]
Theta0_Navascues <- Navascues_data[,1]
Theta1_Navascues <- Navascues_data[,2]

Arlequin_data <- read.table("resultadosarlequin.txt",header=T)
tau_Arlequin <- Arlequin_data$tau
Theta0_Arlequin <- Arlequin_data$theta0
Theta1_Arlequin <- Arlequin_data$theta1

	
# beanplot(tau_Arlequin,tau_Navascues,tau_ABC,names=c("LSWH","MPH","ABC"),ylab=YLab[j],main=Title[j],col = c("#CAB2D6", "#33A02C", "#B2DF8A"), border = "#CAB2D6",maxstripline=0, cex.lab = 2, cex.main = 2, cex.axis = 2,overallline=AbLinePlace[j])


boxplot(tau_Arlequin,tau_Navascues,tau_ABC,ylab=expression(tau),main=Title[j], cex.lab = 2.5, cex.main = 2.5, cex.axis = 2)
#mtext("Tau (real value = 3)", WEST <- 2, at = 3, line = 2, cex = 2)
mtext("LSWH", SOUTH <- 1, at = 1, line = 2, cex = 1.5)
mtext("MPH", SOUTH <- 1, at = 2, line = 2, cex = 1.5)
mtext("ABC", SOUTH <- 1, at = 3, line = 2, cex = 1.5)
abline(a=AbLinePlace[j],b=0,lty=2)

}
dev.off()

#### Theta 1 estimations

Directory <- c("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SupplementaryFigure3/Results/Set2/","/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SupplementaryFigure3/Results/Set3/","/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SupplementaryFigure3/Results/Set4/")

#Title <- c(expression(paste("A) ",tau," = 3")), expression(paste("B) ",tau," = 6")), expression(paste("C) ",tau," = 9")))
Title <- c("A)","B)","C)")
YLab <- c(paste(expression(Theta_1)," (real value = 30)"),paste(expression(Theta_1)," (real value = 30)"),paste(expression(Theta_1)," (real value = 30)"))

Ylimits <- c(14,5.5,5.5)
AbLinePlace <- c(30,30,30)

pdf("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure4_SupplementaryFigure4/SuppFigure4.pdf",width=21/2,height=3.5)
par(mfrow=c(1,3), mar=c(5,6,4,2))

VectorLabels

require("beanplot")

for (j in 1:3){
	
	setwd(Directory[j])
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
	
	Navascues_data <- read.table("tauNavascues.txt")
	tau_Navascues <- Navascues_data[,3]
	Theta0_Navascues <- Navascues_data[,1]
	Theta1_Navascues <- Navascues_data[,2]
	
	Arlequin_data <- read.table("resultadosarlequin.txt",header=T)
	tau_Arlequin <- Arlequin_data$tau
	Theta0_Arlequin <- Arlequin_data$theta0
	Theta1_Arlequin <- Arlequin_data$theta1
	
	
# beanplot(tau_Arlequin,tau_Navascues,tau_ABC,names=c("LSWH","MPH","ABC"),ylab=YLab[j],main=Title[j],col = c("#CAB2D6", "#33A02C", "#B2DF8A"), border = "#CAB2D6",maxstripline=0, cex.lab = 2, cex.main = 2, cex.axis = 2,overallline=AbLinePlace[j])
	
	
	boxplot(log10(Theta1_Arlequin),log10(Theta1_Navascues),log10(theta1_ABC),ylab=expression(theta[1]),main=Title[j], cex.lab = 3, cex.main = 3, cex.axis = 2, ylim=c(0,Ylimits[j]),yaxt="n")
	if (j> 1){
	axis(2,at=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14),labels=c(expression(10^1),expression(10^2),expression(10^3),expression(10^4),expression(10^5),expression(10^6),expression(10^7),expression(10^8),expression(10^9),expression(10^10),expression(10^11),expression(10^12),expression(10^13),expression(10^14)),cex.lab=2, cex.axis=2, cex = 2)
	}else{
		axis(2,at=c(1,5,9,13),labels=c(expression(10^1),expression(10^5),expression(10^9),expression(10^13)),cex.lab=2, cex.axis=2, cex = 2)
	}
#mtext("Tau (real value = 3)", WEST <- 2, at = 3, line = 2, cex = 2)
	mtext("LSWH", SOUTH <- 1, at = 1, line = 2, cex = 1.5)
	mtext("MPH", SOUTH <- 1, at = 2, line = 2, cex = 1.5)
	mtext("ABC", SOUTH <- 1, at = 3, line = 2, cex = 1.5)
	abline(a=log10(AbLinePlace[j]),b=0,lty=2)
	
}
dev.off()


