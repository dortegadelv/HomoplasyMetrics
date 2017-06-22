######### Substitute the directory appropriately to read the data!
### Make the Directory vector point to the direction of the results from the Figure3_SupplementaryFigure3 folder

Directory <- c("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SuppTable1/Results/Set2/","/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SuppTable1/Results/Set3/","/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SuppTable1/Results/Set4/")

#Title <- c(expression(paste("A) ",tau," = 3")), expression(paste("B) ",tau," = 6")), expression(paste("C) ",tau," = 9")))
Title <- c("A)","B)","C)")
YLab <- c("Tau (real value = 3)","Tau (real value = 6)","Tau (real value = 9)")

AbLinePlace <- c(3,6,9)

pdf("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure4_SupplementaryFigure2and5_SuppTable2and3/Figure4.pdf",width=21/2,height=3.5)
par(mfrow=c(1,3), mar=c(5,6,4,2))

require("beanplot")

Coverage50 <- c(0,0,0)
Coverage75 <- c(0,0,0)
Coverage90 <- c(0,0,0)

Coverage50Mean <- c(0,0,0)
Coverage75Mean <- c(0,0,0)
Coverage90Mean <- c(0,0,0)

Coverage50Median <- c(0,0,0)
Coverage75Median <- c(0,0,0)
Coverage90Median <- c(0,0,0)

RelativeBiasTauABC <- c(0,0,0)
RelativeBiasTauArlequin <- c(0,0,0)
RelativeBiasTauNavascues <- c(0,0,0)

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
meantau_ABC <- c()
theta0_ABC <- c()
theta1_ABC <- c()
meantheta1_ABC <- c()

number_archives <- 1:100
Quantilestau <- matrix(,ncol=7,nrow=0)
Quantilestheta1 <- matrix(,ncol=7,nrow=0)
QuantilesMeantau <- matrix(,ncol=7,nrow=0)
QuantilesMeantheta1 <- matrix(,ncol=7,nrow=0)
QuantilesMediantau <- matrix(,ncol=7,nrow=0)
QuantilesMediantheta1 <- matrix(,ncol=7,nrow=0)

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
    Quantilestau <- rbind(Quantilestau,quantile(timeAR,probs=c(0.05,0.125,0.25,0.5,0.75,0.875,0.95)))
	d <- density(timeAR)
	tau_ABC[i] <- d$x[d$y==max(d$y)]
    meantau_ABC <- c(meantau_ABC, mean(timeAR))
	real_tau[i] <- 3
	d <- density(dat$T1)
	theta1_ABC[i] <- d$x[d$y==max(d$y)]
    meantheta1_ABC <- c(meantheta1_ABC,mean(dat$T1))
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

SlightlyUp <- max (c(tau_ABC,tau_Arlequin,tau_Navascues)) + 0.2 * max (c(tau_ABC,tau_Arlequin,tau_Navascues))
SlightlyTextUp <- max (c(tau_ABC,tau_Arlequin,tau_Navascues)) + 0.0 * max (c(tau_ABC,tau_Arlequin,tau_Navascues))
SlightlyDown <- min (c(tau_ABC,tau_Arlequin,tau_Navascues))

RelativeBiasTauABC[j] <- mean((tau_ABC-AbLinePlaceTau[j])/AbLinePlaceTau[j])
RelativeBiasTauArlequin[j] <- mean((tau_Arlequin-AbLinePlaceTau[j])/AbLinePlaceTau[j])
RelativeBiasTauNavascues[j] <- mean((tau_Navascues-AbLinePlaceTau[j])/AbLinePlaceTau[j])

# beanplot(tau_Arlequin,tau_Navascues,tau_ABC,names=c("LSWH","MPH","ABC"),ylab=YLab[j],main=Title[j],col = c("#CAB2D6", "#33A02C", "#B2DF8A"), border = "#CAB2D6",maxstripline=0, cex.lab = 2, cex.main = 2, cex.axis = 2,overallline=AbLinePlace[j])


boxplot(tau_Arlequin,tau_Navascues,tau_ABC,ylab=expression(tau),main=Title[j], cex.lab = 2.5, cex.main = 2.5, cex.axis = 2, ylim = c(SlightlyDown,SlightlyTextUp))
#mtext("Tau (real value = 3)", WEST <- 2, at = 3, line = 2, cex = 2)
mtext("LSWH", SOUTH <- 1, at = 1, line = 2, cex = 1.5)
mtext("MPH", SOUTH <- 1, at = 2, line = 2, cex = 1.5)
mtext("ABC", SOUTH <- 1, at = 3, line = 2, cex = 1.5)
# text(1,SlightlyTextUp,round(RelativeBiasTauArlequin[j],3),cex=1.5)
# text(2,SlightlyTextUp,round(RelativeBiasTauNavascues[j],3),cex=1.5)
# text(3,SlightlyTextUp,round(RelativeBiasTauABC[j],3),cex=1.5)

abline(a=AbLinePlace[j],b=0,lty=2)

}
dev.off()
Table <- rbind(RelativeBiasTauABC,RelativeBiasTauArlequin,RelativeBiasTauNavascues)
# write.table(Table,file="/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure4_SupplementaryFigure2and5_SuppTable2and3/RelativeBiasTau.txt",sep="\t")

#### Theta 1 estimations

Directory <- c("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SuppTable1/Results/Set2/","/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SuppTable1/Results/Set3/","/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SuppTable1/Results/Set4/")

#Title <- c(expression(paste("A) ",tau," = 3")), expression(paste("B) ",tau," = 6")), expression(paste("C) ",tau," = 9")))
Title <- c("A)","B)","C)")
YLab <- c(paste(expression(Theta_1)," (real value = 30)"),paste(expression(Theta_1)," (real value = 30)"),paste(expression(Theta_1)," (real value = 30)"))

Ylimits <- c(14,5.5,5.5)
AbLinePlace <- c(30,30,30)

pdf("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure4_SupplementaryFigure2and5_SuppTable2and3/SuppFigure5.pdf",width=21/2,height=3.5)
par(mfrow=c(1,3), mar=c(5,6,4,2))

VectorLabels

require("beanplot")

RelativeBiasTheta1ABC <- c(0,0,0)
RelativeBiasTheta1Arlequin <- c(0,0,0)
RelativeBiasTheta1Navascues <- c(0,0,0)

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
    meantau_ABC <- c()
	theta0_ABC <- c()
	theta1_ABC <- c()
    meantheta1_ABC <- c()
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
        meantau_ABC <- c(meantau_ABC, mean(timeAR))
		real_tau[i] <- 3
		d <- density(dat$T1)
		theta1_ABC[i] <- d$x[d$y==max(d$y)]
        meantheta1_ABC <- c(meantheta1_ABC,mean(dat$T1))
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

SlightlyUp <- max (c(log10(Theta1_Arlequin),log10(Theta1_Navascues),log10(theta1_ABC))) + 0.2 * max (c(log10(Theta1_Arlequin),log10(Theta1_Navascues),log10(theta1_ABC)))
SlightlyTextUp <- max (c(log10(Theta1_Arlequin),log10(Theta1_Navascues),log10(theta1_ABC))) + 0.05 * max (c(log10(Theta1_Arlequin),log10(Theta1_Navascues),log10(theta1_ABC)))
SlightlyDown <- min (c(log10(Theta1_Arlequin),log10(Theta1_Navascues),log10(theta1_ABC)))

RelativeBiasTheta1ABC[j] <- mean((theta1_ABC-30)/30)
RelativeBiasTheta1Arlequin[j] <- mean((Theta1_Arlequin-30)/30)
RelativeBiasTheta1Navascues[j] <- mean((Theta1_Navascues-30)/30)


	
	boxplot(log10(Theta1_Arlequin),log10(Theta1_Navascues),log10(theta1_ABC),ylab=expression(theta[1]),main=Title[j], cex.lab = 3, cex.main = 3, cex.axis = 2, yaxt="n", ylim = c(SlightlyDown,SlightlyTextUp))
    # ylim=c(0,Ylimits[j])
	if (j> 2){
	axis(2,at=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14),labels=c(expression(10^1),expression(10^2),expression(10^3),expression(10^4),expression(10^5),expression(10^6),expression(10^7),expression(10^8),expression(10^9),expression(10^10),expression(10^11),expression(10^12),expression(10^13),expression(10^14)),cex.lab=2, cex.axis=2, cex = 2)
	}else{
		axis(2,at=c(1,5,9,13),labels=c(expression(10^1),expression(10^5),expression(10^9),expression(10^13)),cex.lab=2, cex.axis=2, cex = 2)
	}
#mtext("Tau (real value = 3)", WEST <- 2, at = 3, line = 2, cex = 2)
	mtext("LSWH", SOUTH <- 1, at = 1, line = 2, cex = 1.5)
	mtext("MPH", SOUTH <- 1, at = 2, line = 2, cex = 1.5)
	mtext("ABC", SOUTH <- 1, at = 3, line = 2, cex = 1.5)
	abline(a=log10(AbLinePlace[j]),b=0,lty=2)
    #    text(1,SlightlyTextUp,round(RelativeBiasTheta1Arlequin[j],3),cex=1.5)
    #    text(2,SlightlyTextUp,round(RelativeBiasTheta1Navascues[j],3),cex=1.5)
    #    text(3,SlightlyTextUp,round(RelativeBiasTheta1ABC[j],3),cex=1.5)

}
dev.off()
Table <- rbind(RelativeBiasTheta1ABC,RelativeBiasTheta1Arlequin,RelativeBiasTheta1Navascues)
#write.table(Table,file="/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure4_SupplementaryFigure2and5_SuppTable2and3/RelativeBiasTheta1.txt",sep="\t")


#### Mean vs Median vs Mode estimations


Directory <- c("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SuppTable1/Results/Set2/","/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SuppTable1/Results/Set3/","/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure3_SuppTable1/Results/Set4/")

#Title <- c(expression(paste("A) ",tau," = 3")), expression(paste("B) ",tau," = 6")), expression(paste("C) ",tau," = 9")))
Title <- c("A)","B)","C)")
YLab <- c(paste(expression(Theta_1)," (real value = 30)"),paste(expression(Theta_1)," (real value = 30)"),paste(expression(Theta_1)," (real value = 30)"))

Ylimits <- c(14,5.5,5.5)
AbLinePlace <- c(30,30,30)
AbLinePlaceTau <- c(3,6,9)

pdf("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure4_SupplementaryFigure2and5_SuppTable2and3/SuppFigure2.pdf")
par(mfrow=c(3,2), mar=c(3,6,4,1))

VectorLabels

require("beanplot")

Coverage50 <- c(0,0,0)
Coverage75 <- c(0,0,0)
Coverage90 <- c(0,0,0)

Coverage50Theta1 <- c(0,0,0)
Coverage75Theta1 <- c(0,0,0)
Coverage90Theta1 <- c(0,0,0)

Coverage50P <- c(0,0,0)
Coverage75P <- c(0,0,0)
Coverage90P <- c(0,0,0)

Coverage50MSH <- c(0,0,0)
Coverage75MSH <- c(0,0,0)
Coverage90MSH <- c(0,0,0)

Coverage50DH <- c(0,0,0)
Coverage75DH <- c(0,0,0)
Coverage90DH <- c(0,0,0)

Coverage50Median <- c(0,0,0)
Coverage75Median <- c(0,0,0)
Coverage90Median <- c(0,0,0)

RelativeBiasTau <- c(0,0,0)
RelativeBiasMeanTau <- c(0,0,0)
RelativeBiasMedianTau <- c(0,0,0)

RelativeBiasTheta1 <- c(0,0,0)
RelativeBiasMeanTheta1 <- c(0,0,0)
RelativeBiasMedianTheta1 <- c(0,0,0)

RelativeBiasP <- c(0,0,0)
RelativeBiasMeanP <- c(0,0,0)
RelativeBiasMedianP <- c(0,0,0)

RelativeBiasDH <- c(0,0,0)
RelativeBiasMeanDH <- c(0,0,0)
RelativeBiasMedianDH <- c(0,0,0)

RelativeBiasMSH <- c(0,0,0)
RelativeBiasMeanMSH <- c(0,0,0)
RelativeBiasMedianMSH <- c(0,0,0)

MainLabels = c("A)","C)","E)")
MainThetaLabels = c("B)","D)","F)")

for (j in 1:3){
    
    setwd(Directory[j])
    P <- c()
    MSH <- c()
    DH <- c()
    P_estimate <- c()
    MSH_estimate <- c()
    DH_estimate <- c()
    Pmean_estimate <- c()
    MSHmean_estimate <- c()
    DHmean_estimate <- c()
    Pmedian_estimate <- c()
    MSHmedian_estimate <- c()
    DHmedian_estimate <- c()
    real_tau <- c()
    real_theta0 <- c()
    real_theta1 <- c()
    tau_ABC <- c()
    meantau_ABC <- c()
    mediantau_ABC <- c()
    theta0_ABC <- c()
    theta1_ABC <- c()
    meantheta1_ABC <- c()
    mediantheta1_ABC <- c()
    number_archives <- 1:100
    Quantilestau <- matrix(,ncol=7,nrow=0)
    Quantilestheta1 <- matrix(,ncol=7,nrow=0)
    QuantilesMeantau <- matrix(,ncol=7,nrow=0)
    QuantilesMeantheta1 <- matrix(,ncol=7,nrow=0)
    QuantilesMediantau <- matrix(,ncol=7,nrow=0)
    QuantilesMediantheta1 <- matrix(,ncol=7,nrow=0)

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
        Quantilestau <- rbind(Quantilestau,quantile(timeAR,probs=c(0.05,0.125,0.25,0.5,0.75,0.875,0.95)))
        QuantilesMeantau <- rbind(QuantilesMeantau,quantile(timeAR,probs=c(0.05,0.125,0.25,0.5,0.75,0.875,0.95)))
        QuantilesMediantau <- rbind(QuantilesMediantau,quantile(timeAR,probs=c(0.05,0.125,0.25,0.5,0.75,0.875,0.95)))
        tau_ABC[i] <- d$x[d$y==max(d$y)]
        meantau_ABC <- c(meantau_ABC, mean(timeAR))
        real_tau[i] <- 3
        d <- density(dat$T1)
        theta1_ABC[i] <- d$x[d$y==max(d$y)]
        meantheta1_ABC <- c(meantheta1_ABC,mean(dat$T1))
        Quantilestheta1 <- rbind(Quantilestheta1,quantile(dat$T1,probs=c(0.05,0.125,0.25,0.5,0.75,0.875,0.95)))
        QuantilesMeantheta1 <- rbind(QuantilesMeantheta1,quantile(dat$T1,probs=c(0.05,0.125,0.25,0.5,0.75,0.875,0.95)))
        QuantilesMediantheta1 <- rbind(QuantilesMediantheta1,quantile(dat$T1,probs=c(0.05,0.125,0.25,0.5,0.75,0.875,0.95)))
        d <- density(dat$SASHloc)
        MSH_estimate[i] <- d$x[d$y==max(d$y)]
        MSHmean_estimate[i] <- mean(dat$SASHloc)
        MSHmedian_estimate[i] <- median(dat$SASHloc)
        d <- density(dat$SASH)
        P_estimate[i] <- d$x[d$y==max(d$y)]
        Pmean_estimate[i] <- mean(dat$SASH)
        Pmedian_estimate[i] <- median(dat$SASH)
        d <- density(dat$SHdist)
        DH_estimate[i] <- d$x[d$y==max(d$y)]
        DHmean_estimate[i] <- mean(dat$SHdist)
        DHmedian_estimate[i] <- median(dat$SHdist)
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
        if ((P[i] >= QuantilesP[3]) && (P[i] <= QuantilesP[5])){
        Coverage50P[j] <- Coverage50P[j] + 1
        }
        if ((P[i] >= QuantilesP[2]) && (P[i] <= QuantilesP[6])){
            Coverage75P[j] <- Coverage75P[j] + 1
        }
        if ((P[i] >= QuantilesP[1]) && (P[i] <= QuantilesP[7])){
            Coverage90P[j] <- Coverage90P[j] + 1
        }
        
        if ((MSH[i] >= QuantilesMSH[3]) && (MSH[i] <= QuantilesMSH[5])){
            Coverage50MSH[j] <- Coverage50MSH[j] + 1
        }
        if ((MSH[i] >= QuantilesMSH[2]) && (MSH[i] <= QuantilesMSH[6])){
            Coverage75MSH[j] <- Coverage75MSH[j] + 1
        }
        if ((MSH[i] >= QuantilesMSH[1]) && (MSH[i] <= QuantilesMSH[7])){
            Coverage90MSH[j] <- Coverage90MSH[j] + 1
        }
        
        if ((DH[i] >= QuantilesDH[3]) && (DH[i] <= QuantilesDH[5])){
            Coverage50DH[j] <- Coverage50DH[j] + 1
        }
        if ((DH[i] >= QuantilesDH[2]) && (DH[i] <= QuantilesDH[6])){
            Coverage75DH[j] <- Coverage75DH[j] + 1
        }
        if ((DH[i] >= QuantilesDH[1]) && (DH[i] <= QuantilesDH[7])){
            Coverage90DH[j] <- Coverage90DH[j] + 1
        }


    }
    
    for (i in 1:100){
        if ((AbLinePlaceTau[j] >=Quantilestau[i,3]) && (AbLinePlaceTau[j] <= Quantilestau[i,5])){
            Coverage50[j] <- Coverage50[j] + 1
        }
    }

    for (i in 1:100){
        if ((AbLinePlaceTau[j] >=Quantilestau[i,2]) && (AbLinePlaceTau[j] <= Quantilestau[i,6])){
            Coverage75[j] <- Coverage75[j] + 1
        }
    }

    for (i in 1:100){
        if ((AbLinePlaceTau[j] >=Quantilestau[i,1]) && (AbLinePlaceTau[j] <= Quantilestau[i,7])){
            Coverage90[j] <- Coverage90[j] + 1
        }
    }

for (i in 1:100){
    if ((30 >=Quantilestheta1[i,3]) && (30 <= Quantilestheta1[i,5])){
        Coverage50Theta1[j] <- Coverage50Theta1[j] + 1
    }
}

for (i in 1:100){
    if ((30 >=Quantilestheta1[i,2]) && (30 <= Quantilestheta1[i,6])){
        Coverage75Theta1[j] <- Coverage75Theta1[j] + 1
    }
}

for (i in 1:100){
    if ((30 >=Quantilestheta1[i,1]) && (30 <= Quantilestheta1[i,7])){
        Coverage90Theta1[j] <- Coverage90Theta1[j] + 1
    }
}


    RelativeBiasTau[j] <- mean((tau_ABC-AbLinePlaceTau[j])/AbLinePlaceTau[j])
    RelativeBiasMeanTau[j] <- mean((meantau_ABC-AbLinePlaceTau[j])/AbLinePlaceTau[j])
    RelativeBiasMedianTau[j] <- mean((Quantilestau[,3]-AbLinePlaceTau[j])/AbLinePlaceTau[j])

    RelativeBiasTheta1[j] <- mean((tau_ABC-30)/30)
    RelativeBiasMeanTheta1[j] <- mean((meantau_ABC-30)/30)
    RelativeBiasMedianTheta1[j] <- mean((Quantilestau[,3]-30)/30)
    
    P[P==0] <- NA
    RelativeBiasP[j] <- mean((P_estimate-P)/P, na.rm=TRUE)
    RelativeBiasMeanP[j] <- mean((Pmean_estimate-P)/P, na.rm=TRUE)
    RelativeBiasMedianP[j] <- mean((Pmedian_estimate-P)/P, na.rm=TRUE)
    
    RelativeBiasMSH[j] <- mean((MSH_estimate-MSH)/MSH)
    RelativeBiasMeanMSH[j] <- mean((MSHmean_estimate-MSH)/MSH)
    RelativeBiasMedianMSH[j] <- mean((MSHmedian_estimate-MSH)/MSH)
    
    RelativeBiasDH[j] <- mean((DH_estimate-DH)/DH)
    RelativeBiasMeanDH[j] <- mean((DHmean_estimate-DH)/DH)
    RelativeBiasMedianDH[j] <- mean((DHmedian_estimate-DH)/DH)

    Navascues_data <- read.table("tauNavascues.txt")
    tau_Navascues <- Navascues_data[,3]
    Theta0_Navascues <- Navascues_data[,1]
    Theta1_Navascues <- Navascues_data[,2]
    
    Arlequin_data <- read.table("resultadosarlequin.txt",header=T)
    tau_Arlequin <- Arlequin_data$tau
    Theta0_Arlequin <- Arlequin_data$theta0
    Theta1_Arlequin <- Arlequin_data$theta1
    
    
    # beanplot(tau_Arlequin,tau_Navascues,tau_ABC,names=c("LSWH","MPH","ABC"),ylab=YLab[j],main=Title[j],col = c("#CAB2D6", "#33A02C", "#B2DF8A"), border = "#CAB2D6",maxstripline=0, cex.lab = 2, cex.main = 2, cex.axis = 2,overallline=AbLinePlace[j])
    SlightlyUp <- max (c(Quantilestau[,3],meantau_ABC,tau_ABC)) + 0.2 * max (c(Quantilestau[,3],meantau_ABC,tau_ABC))
    SlightlyTextUp <- max (c(Quantilestau[,3],meantau_ABC,tau_ABC)) + 0.0 * max (c(Quantilestau[,3],meantau_ABC,tau_ABC))
    SlightlyDown <- min (c(Quantilestau[,3],meantau_ABC,tau_ABC))

    boxplot(Quantilestau[,3],meantau_ABC,tau_ABC, cex.lab = 3, cex.main = 3, cex.axis = 2,ylab=expression(tau), ylim = c(SlightlyDown,SlightlyTextUp), main = MainLabels[j])
    abline(h=AbLinePlaceTau[j],lty="dashed")
    mtext("Median", SOUTH <- 1, at = 1, line = 2, cex = 1.5)
    mtext("Mean", SOUTH <- 1, at = 2, line = 2, cex = 1.5)
    mtext("Mode", SOUTH <- 1, at = 3, line = 2, cex = 1.5)
    #    text(1,SlightlyTextUp,round(RelativeBiasMedianTau[j],3),cex=1.5)
    #    text(2,SlightlyTextUp,round(RelativeBiasMeanTau[j],3),cex=1.5)
    #    text(3,SlightlyTextUp,round(RelativeBiasTau[j],3),cex=1.5)

    SlightlyUp <- max (c(Quantilestheta1[,3],meantheta1_ABC,theta1_ABC)) + 0.2 * max (c(Quantilestheta1[,3],meantheta1_ABC,theta1_ABC))
    SlightlyTextUp <- max (c(Quantilestheta1[,3],meantheta1_ABC,theta1_ABC)) + 0.05 * max (c(Quantilestheta1[,3],meantheta1_ABC,theta1_ABC))
    SlightlyDown <- min (c(Quantilestheta1[,3],meantheta1_ABC,theta1_ABC))

    boxplot(Quantilestheta1[,3],meantheta1_ABC,theta1_ABC, cex.lab = 3, cex.main = 3, cex.axis = 2,ylab=expression(theta[1]), ylim = c(SlightlyDown,SlightlyTextUp), main = MainThetaLabels[j])
    abline(h=AbLinePlace[j],lty="dashed")
    mtext("Median", SOUTH <- 1, at = 1, line = 2, cex = 1.5)
    mtext("Mean", SOUTH <- 1, at = 2, line = 2, cex = 1.5)
    mtext("Mode", SOUTH <- 1, at = 3, line = 2, cex = 1.5)
    #    text(1,SlightlyTextUp,round(RelativeBiasMedianTheta1[j],3),cex=1.5)
    #    text(2,SlightlyTextUp,round(RelativeBiasMeanTheta1[j],3),cex=1.5)
    #    text(3,SlightlyTextUp,round(RelativeBiasTheta1[j],3),cex=1.5)

# boxplot(log10(Theta1_Arlequin),log10(Theta1_Navascues),log10(theta1_ABC),ylab=expression(theta[1]),main=Title[j], cex.lab = 3, cex.main = 3, cex.axis = 2, ylim=c(0,Ylimits[j]),yaxt="n")
    if (j> 1){
        #axis(2,at=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14),labels=c(expression(10^1),expression(10^2),expression(10^3),expression(10^4),expression(10^5),expression(10^6),expression(10^7),expression(10^8),expression(10^9),expression(10^10),expression(10^11),expression(10^12),expression(10^13),expression(10^14)),cex.lab=2, cex.axis=2, cex = 2)
    }else{
        # axis(2,at=c(1,5,9,13),labels=c(expression(10^1),expression(10^5),expression(10^9),expression(10^13)),cex.lab=2, cex.axis=2, cex = 2)
    }
    #mtext("Tau (real value = 3)", WEST <- 2, at = 3, line = 2, cex = 2)
    #    mtext("LSWH", SOUTH <- 1, at = 1, line = 2, cex = 1.5)
    #    mtext("MPH", SOUTH <- 1, at = 2, line = 2, cex = 1.5)
    #    mtext("ABC", SOUTH <- 1, at = 3, line = 2, cex = 1.5)
    #    abline(a=log10(AbLinePlace[j]),b=0,lty=2)
    
}
dev.off()

Table <- cbind(RelativeBiasTau,RelativeBiasMeanTau,RelativeBiasMedianTau,RelativeBiasTheta1,RelativeBiasMeanTheta1,RelativeBiasMedianTheta1,RelativeBiasP,RelativeBiasMeanP,RelativeBiasMedianP,RelativeBiasMSH,RelativeBiasMeanMSH,RelativeBiasMedianMSH,RelativeBiasDH,RelativeBiasMeanDH,RelativeBiasMedianDH,Coverage50,Coverage75,Coverage90,Coverage50Theta1,Coverage75Theta1,Coverage90Theta1,Coverage50P,Coverage75P,Coverage90P,Coverage50DH,Coverage75DH,Coverage90DH,Coverage50MSH,Coverage75MSH,Coverage90MSH)

write.table(Table,file="/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure4_SupplementaryFigure2and5_SuppTable2and3/SuppTable2and3.txt",sep="\t")



