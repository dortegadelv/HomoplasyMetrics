setwd("/Users/vicentediegoortegadelvecchyo/Dropbox/Documents/Pinero/Articulo_homoplasia/Articulo/VersionesDeArticulo/HomoplasyPaperFigures/Figures/Table1")

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

dat <- read.table("Cluster2_resultados.txt",header=T)
u = 5.5 *( 10^(-5))
L=7
Theta1= dat$T1
N=Theta1/(2*L*u)
tMS=dat$Time
timeMS = tMS*2*N
timeAR = (2*L*u)*timeMS
d <- density(timeAR)
tau_ABC <- d$x[d$y==max(d$y)]
tau_ABC

d <- density(dat$SASHloc)
MSH_estimate <- d$x[d$y==max(d$y)]
MSH_estimate
quantile(dat$SASHloc,probs=c(0.025,0.975))
d <- density(dat$SHdist)
DH_estimate <- d$x[d$y==max(d$y)]
DH_estimate
quantile(dat$SHdist,probs=c(0.025,0.975))

d <- density (dat$T1)
estimateT1 <- d$x[d$y==max(d$y)]
estimateT1


tau_ABC <- read.table("ConfidenceIntervalABC",header=F)


quantile (tau_ABC[,2],probs=c(0.025,0.975))

Years <- (quantile(tau_ABC[,2],probs=c(0.025,0.975))/(2* u*L))*42.5
Years


Navascues <- read.table("tauNavascues.txt",header=F)
d <- density(Navascues$V1)
quantile(Navascues$V1,probs=c(0.025,0.975))

d <- density(Navascues$V2)
quantile(Navascues$V2,probs=c(0.025,0.975))

d <- density(Navascues$V3)
quantile(Navascues$V3,probs=c(0.025,0.975))

#The values of Tau Arlequin were taken from running Arlequin

TauArlequin <- 4.074
range <- 1.359
range2 <- 6.086

Years <- (TauArlequin/(2* u*L))*42.5
Years

Years <- (range/(2* u*L))*42.5
Years

Years <- (range2/(2* u*L))*42.5
Years

Years <- (5.994/(2* u*L))*42.5
Years

Years <- (quantile(Navascues$V3,probs=c(0.025,0.975))/(2* u*L))*42.5
Years

