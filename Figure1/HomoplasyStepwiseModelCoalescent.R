######### Substitute the directory appropriately to read the data!
############### This R script generates Figure 1 from the paper ###############


### Point to the directory containing this script and the data in the MyDir variable

# MyDir <-"/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure1"

MyDir <- "/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Figure1"

setwd(MyDir)

L <- 6

### Read data and get mean values of homoplasy 

PartialDH <- c()
PartialMSH <- c()
PartialP <- c()

BiggerSampleData <- read.table("ConcatenatedDataStepwiseCoalModel.txt")
PBigSample <- c()
MSHBigSample <- c()
DHBigSample <- c()

for (i in 1:10){
	
	Start <- (i-1)*100 +1
	End <- i*100
	DH <- mean(BiggerSampleData[Start:End,6])
	MSH <- mean(BiggerSampleData[Start:End,1])
	P <- mean(BiggerSampleData[Start:End,4])
	
	PartialP <- c(PartialP,P)
	PartialMSH <- c(PartialMSH,MSH)
	PartialDH <- c(PartialDH,DH)
}


IS_MSH <- c()
SMM_MSH <- c()
IS_P <- c()
SMM_P <- c()
IS_DH <- c()
SMM_DH <- c()

for (i in 1:10){
	
	Start <- (i-1)*100 +1
	End <- i*100
	IS_MSH_t <- mean(BiggerSampleData[Start:End,18])
	SMM_MSH_t <- mean(BiggerSampleData[Start:End,19])
	IS_P_t <- mean(BiggerSampleData[Start:End,22])
	SMM_P_t <- mean(BiggerSampleData[Start:End,23])
	IS_DH_t <- mean(BiggerSampleData[Start:End,20])
	SMM_DH_t <- mean(BiggerSampleData[Start:End,21])
	
	IS_MSH <- c(IS_MSH,IS_MSH_t)
	SMM_MSH <- c(SMM_MSH,SMM_MSH_t)
	IS_P <- c(IS_P,IS_P_t)
	SMM_P <- c(SMM_P,SMM_P_t)
	IS_DH <- c(IS_DH,IS_DH_t)
	SMM_DH <- c(SMM_DH,SMM_DH_t)
}

######## Next.- All the functions required to calculate the homoplasy values


### Pre-prepare differences results from Logozar-Hizak 2001 random walk differences paper. This will be
### used to calculate pi_smm

tauvec<-1:100
res<-c()
altres <- c()
altres <- c(altres,0)
for (n in tauvec){
	
	
	x<-rbinom(10000,n,0.5)
	res<-c(res,mean(abs(-n + 2*x)))
	
	if (n %% 2 == 0){
		TermOne = 1/ (2^(n-2))
		TermTwo = n / 2
		TermThree = factorial(n-1) / (factorial(n/2) * factorial((n-1) -  n/2))
		Multiplication <- TermOne * TermTwo * TermThree
		altres <- c(altres,Multiplication)
	}else {
		TermOne = 1 / (2^(n-1))
		TermTwo = (n + 1) / 2
		TermThree = factorial(n) / (factorial((n + 1)/2) * factorial( n - (n + 1)/2) )
		Multiplication <- TermOne * TermTwo * TermThree
		altres <- c(altres,Multiplication)
	}
}

### Function to calculate F_SMM 

comb = function(n, x) {
	return(factorial(n) / (factorial(x) * factorial(n-x)))
}


F_smm = function(time) {
	CurrentDpois <- 0
	j <- 0
	FSMM <- 0
	for (j in 0:12){
		CurrentDpois <- ppois(j,time)
		CurrentProbability <- dpois(j,time)
		if (j == 0){
			FSMM <- FSMM + CurrentProbability
#			print(FSMM)
		}
		if (j == 2){
## Chance that the two mutations landed on the same microsatellite
			Combinations <- comb(6,1)
			FSMM <- FSMM + CurrentProbability* Combinations* (1/6)^(2)*dbinom(j/2,j,0.5)
		}
		if (j == 4){
## Chance that the four mutations landed on the same microsatellite
			Combinations <- comb(6,1)
			FSMM <- FSMM + CurrentProbability* Combinations* (1/6)^(4)*dbinom(j/2,j,0.5)
## Chance that we have two mutations, those two on two different microsatellites
			Combinations <- comb(6,2)
			FSMM <- FSMM + CurrentProbability* Combinations *(factorial(4)/(factorial(2)*factorial(2)))* (1/6)^(4)*dbinom(1,2,0.5)*dbinom(1,2,0.5)
		}
		if (j == 6){
## Chance that the six mutations landed on the same microsatellite
			Combinations <- comb(6,1)
			FSMM <- FSMM + CurrentProbability* Combinations* (1/6)^(6)*dbinom(j/2,j,0.5)
## Chance that you have 3 microsatellites with 2 mutations each
			Combinations <- comb(6,3)
			FSMM <- FSMM + CurrentProbability* Combinations *(factorial(6)/(factorial(2)*factorial(2)*factorial(2)))* (1/6)^(6)*dbinom(1,2,0.5)*dbinom(1,2,0.5)*dbinom(1,2,0.5)
		}
		if (j == 8){
## Chance that the eight mutations landed on the same microsatellite
			Combinations <- comb(6,1)
			FSMM <- FSMM + CurrentProbability* Combinations* (1/6)^(8)*dbinom(j/2,j,0.5)
## Chance that you have 4 microsatellites with 2 mutations each
			Combinations <- comb(6,4)
			FSMM <- FSMM + CurrentProbability* Combinations *(factorial(8)/(factorial(2)*factorial(2)*factorial(2)*factorial(2)))* (1/6)^(8)*dbinom(1,2,0.5)*dbinom(1,2,0.5)*dbinom(1,2,0.5)*dbinom(1,2,0.5)			
		}
		if (j == 10){
## Chance that the ten mutations landed on the same microsatellite
			Combinations <- comb(6,1)
			FSMM <- FSMM + CurrentProbability* Combinations* (1/6)^(10)*dbinom(j/2,j,0.5)
## Chance that you have 5 microsatellites with 2 mutations each
			Combinations <- comb(6,5)
			FSMM <- FSMM + CurrentProbability* Combinations *(factorial(10)/(factorial(2)*factorial(2)*factorial(2)*factorial(2)*factorial(2)))* (1/6)^(10)*dbinom(1,2,0.5)*dbinom(1,2,0.5)*dbinom(1,2,0.5)*dbinom(1,2,0.5)*dbinom(1,2,0.5)			
		}
		if (j == 12){
## Chance that the twelve mutations landed on the same microsatellite
			Combinations <- comb(6,1)
			FSMM <- FSMM + CurrentProbability* Combinations* (1/6)^(12)*dbinom(j/2,j,0.5)
## Chance that you have 6 microsatellites with 2 mutations each
			Combinations <- comb(6,6)
			FSMM <- FSMM + CurrentProbability* Combinations *(factorial(12)/(factorial(2)*factorial(2)*factorial(2)*factorial(2)*factorial(2)*factorial(2)))* (1/6)^(12)*dbinom(1,2,0.5)*dbinom(1,2,0.5)*dbinom(1,2,0.5)*dbinom(1,2,0.5)*dbinom(1,2,0.5)*dbinom(1,2,0.5)			
		}
#		j <- j + 1
	}
	return (FSMM)
}

### Function to calculate Fi_smm

SiteFSMM = function(time) {
	
	CurrentDpois <- 0
	j <- 0
	CurrentFSMM <- 0
	L <- 6
	while(CurrentDpois < 0.999){
		CurrentFSMM <- CurrentFSMM + dpois(j*2,time/L)*dbinom(j,j*2,0.5)
		CurrentDpois <-ppois(j*2,time/L)
		j <- j + 1
	}
	return(CurrentFSMM)
}

## Function to calculate pi_smm

Pi_SMM = function(time){
	
	CurrentDpois <- 0
	j <- 0
	PiSMM <- 0
	while(CurrentDpois < 0.999){
		CurrentDpois <- CurrentDpois + dpois(j,time/L)
		PiSMM <- PiSMM + L * ((dpois(j,time/6))*altres[j+1])
		j <- j + 1
	}
	return(PiSMM)
}

#### End of functions

## Routine to estimate homoplasy in the step-wise coalescent model

N <- 30/(2*6*5.5e-5)
CumulativeFSMM <- 0
CumulativeFIS <- 0
CumulativeFisSing <- 0
CumulativeFsmmSing <- 0
CumulativePiis <- 0
CumulativePsmm <- 0
CurrentProbabilityOfCoalescence <- 0
CumulativeProbability <- 0
Theory_IS_MSH <- c()
Theory_SMM_MSH <- c()
Theory_IS_P <- c()
Theory_SMM_P <- c()
Theory_IS_DH <- c()
Theory_SMM_DH <- c()
NormalTijCalcPart <- 0

KeyTauTimes <-  1:150*.1
SimTauTimes <- c(1.5,3,4.5,6,7.5,9,10.5,12,13.5,15)

PValues <- c()
MSHValues <- c()
DHValues <- c()

Tij <- 0
SumTermTwo <- 0 

for (j in 1:150){

	CumulativeFSMM <- 0
	CumulativeFIS <- 0
	CumulativeFisSing <- 0
	CumulativeFsmmSing <- 0
	CumulativePiis <- 0
	CumulativePsmm <- 0	
	
for (k in 150:2){

	n <- 150
	TermOne <- 2*((1/(k-1)) - (1/n))
	TermTwo <- (2*(n+1))/(k*(k+1)*(n-1))
	Tij <- Tij + TermOne*TermTwo*2*N
	NormalTijCalcPart <- NormalTijCalcPart + TermOne*TermTwo*2*N
	CurrentGens <- TermOne*2*N
	CurrentTau <- CurrentGens *6*5.5e-5
	
	if (CurrentTau > KeyTauTimes[j]){
	CurrentTau <- KeyTauTimes[j]
	}
	
	print(CurrentTau)
	print(TermTwo)
	CumulativeFSMM <- CumulativeFSMM + TermTwo * F_smm(CurrentTau)
	CumulativeFIS <- CumulativeFIS + TermTwo * exp(-CurrentTau)
	CumulativeFisSing <-CumulativeFisSing + TermTwo * exp(-CurrentTau/6)
	CumulativeFsmmSing <- CumulativeFsmmSing + TermTwo * SiteFSMM(CurrentTau)
	CumulativePiis <- CumulativePiis + TermTwo* (CurrentTau)
	CumulativePsmm <- CumulativePsmm + TermTwo* Pi_SMM(CurrentTau)
	
	
	SumTermTwo <- SumTermTwo + TermTwo
#	CheckTermTwo <- c(CheckTermTwo,TermTwo)
#	CheckTermOne <- c(CheckTermOne,TermOne)
#	CheckTermTwo <- c()
#	CheckTermOne <- c()
}
	Theory_IS_MSH <- c(Theory_IS_MSH,CumulativeFisSing)
	Theory_SMM_MSH <- c(Theory_SMM_MSH,CumulativeFsmmSing)
	Theory_IS_P <- c(Theory_IS_P,CumulativeFIS)
	Theory_SMM_P <- c(Theory_SMM_P,CumulativeFSMM)
	Theory_IS_DH <- c(Theory_IS_DH,CumulativePiis)
	Theory_SMM_DH <- c(Theory_SMM_DH,CumulativePsmm)
	PValues <- c(PValues,(1-CumulativeFIS/CumulativeFSMM))
	MSHValues <- c(MSHValues,(1-CumulativeFisSing/CumulativeFsmmSing))
	DHValues <- c(DHValues,(1-CumulativePsmm/CumulativePiis))
}


pdf("EstimatesVsTheoryMSH_StepwiseCoalModel.pdf")

plot(SimTauTimes,IS_MSH,type="p",ylim=c(0,1),xlim=c(0,15),xlab="Tau",ylab="Fi")
lines(KeyTauTimes,Theory_IS_MSH,lty=2)

lines(SimTauTimes,SMM_MSH,type="p",col="red")
lines(KeyTauTimes,Theory_SMM_MSH,lty=2,col="red")

legend("topright",title="Mutation model",c("ISM","SMM"),pch=1,col=c("black","red"))

dev.off()

pdf("EstimatesVsTheoryDH_StepwiseCoalModel.pdf")

plot(SimTauTimes,IS_DH,type="p",ylim=c(0,13.5),xlim=c(0,15),xlab="Tau",ylab="pi")
lines(KeyTauTimes,Theory_IS_DH,lty=2)

lines(SimTauTimes,SMM_DH,type="p",col="red")
lines(KeyTauTimes,Theory_SMM_DH,lty=2,col="red")

legend("topleft",title="Mutation model",c("ISM","SMM"),pch=1,col=c("black","red"))

dev.off()


pdf("EstimatesVsTheoryP_StepwiseCoalModel.pdf")

plot(SimTauTimes,IS_P,type="p",ylim=c(0,0.9),xlim=c(0,15),xlab="Tau",ylab="F")
lines(KeyTauTimes,Theory_IS_P,lty=2)

lines(SimTauTimes,SMM_P,type="p",col="red")
lines(KeyTauTimes,Theory_SMM_P,lty=2,col="red")

legend("topright",title="Mutation model",c("ISM","SMM"),pch=1,col=c("black","red"))

dev.off()


pdf("HomoplasyValues_StepwiseCoalModel.pdf")
plot(SimTauTimes,PartialP,type="p",ylim=c(0,1),col="red",xlim=c(0,15),xlab="Tau",ylab="Homoplasy")
lines(SimTauTimes,PartialMSH,type="p",col="black")
lines(SimTauTimes,PartialDH,type="p",col="blue")

lines(KeyTauTimes,PValues,type="l",ylim=c(0,1),col="red",lty=2)
lines(KeyTauTimes,MSHValues,col="black",lty=2)
lines(KeyTauTimes,DHValues,col="blue",lty=2)

legend("topright",title="Homoplasy measure",c("P","MSH","DH"),pch=1,col=c("red","black","blue"))

dev.off()


pdf("Figure1.pdf")
par(mfrow = c(2,2),mar=c(4.1,5.1,3.1,1.1))


plot(SimTauTimes,IS_DH,type="p",ylim=c(0,15),xlab=expression(tau),ylab=expression(pi),main="A)",pch=19, cex.lab=1.5,cex.axis=1.25)
lines(KeyTauTimes,Theory_IS_DH,lty=2)

lines(SimTauTimes,SMM_DH,type="p",col="red",pch=19)
lines(KeyTauTimes,Theory_SMM_DH,lty=2,col="red")

legend("topleft",title="Mutation model",c("ISM","SMM"),pch=19,col=c("black","red"),cex=1.25)


plot(SimTauTimes,IS_MSH,type="p",ylim=c(0,1),xlab=expression(tau),ylab=expression(F[i]),main="B)",pch=19, cex.lab=1.5,cex.axis=1.25)
lines(KeyTauTimes,Theory_IS_MSH,lty=2)

lines(SimTauTimes,SMM_MSH,type="p",col="red",pch=19)
lines(KeyTauTimes,Theory_SMM_MSH,lty=2,col="red")

legend("topright",title="Mutation model",c("ISM","SMM"),pch=19,col=c("black","red"),cex=1.25)


plot(SimTauTimes,IS_P,type="p",ylim=c(0,0.3),xlab=expression(tau),ylab="F",main="C)",pch=19, cex.lab=1.5,cex.axis=1.25)
lines(KeyTauTimes,Theory_IS_P,lty=2)

lines(SimTauTimes,SMM_P,type="p",col="red",pch=19)
lines(KeyTauTimes,Theory_SMM_P,lty=2,col="red")

legend("topright",title="Mutation model",c("ISM","SMM"),pch=19,col=c("black","red"),cex=1.25)

# plot(SimTauTimes,PartialP,type="p",ylim=c(0,1),col="red",xlab="Tau",ylab="Homoplasy",main="D)",pch=19)
# lines(SimTauTimes,PartialMSH,type="p",col="black",pch=19)
# lines(SimTauTimes,PartialDH,type="p",col="blue",pch=19)

plot(SimTauTimes,1-IS_P/SMM_P,type="p",ylim=c(0,1),col="red", xlab=expression(tau), ylab="Homoplasy",main="D)",pch=19, cex.lab=1.5,cex.axis=1.25)
lines(SimTauTimes,1-IS_MSH/SMM_MSH,type="p",col="black",pch=19)
lines(SimTauTimes,(IS_DH - SMM_DH)/IS_DH,type="p",col="blue",pch=19)


lines(KeyTauTimes,PValues,type="l",ylim=c(0,1),col="red",lty=2)
lines(KeyTauTimes,MSHValues,col="black",lty=2)
lines(KeyTauTimes,DHValues,col="blue",lty=2)

legend("topright",c("P","MSH","DH"),pch=19,col=c("red","black","blue"),cex=1.25)


dev.off()

