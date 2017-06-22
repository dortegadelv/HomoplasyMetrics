The estimated value of tau_LSWH (4.074) was obtained by running Arlequin on the Pinus caribaea dataset. The upper and lower limits of the 95% confidence interval were also obtained by running Arlequin (1.359-6.086). 

Using a generation time of 42.5 years per generation, and a mutation rate of 5.5 X 10-5 per microsatellite per generation, we obtained an estimated expansion time of 224,900 and the upper and lower limits were equal to (75,000 and 335,900).

To obtain the value of tau_MPH, we ran the software developed by Navascues et al. (2009) Genetics. We obtained an estimated value of tau equal to 5.994 . Then, we go to the folder ConfidenceIntervalNavascues/ and we ran the script Confidence_intervals_simulationstauNavascues.pl to do more than 1000 simulations with the demographic parameters inferred by the Navascues et al. (2009) Genetics software on the Pinus caribaea dataset. We ran those simulations through the Navascues et al. (2009) Genetics software. The results of the parameters inferred from those runs can be found in tauNavascues.txt.

The upper and lower limits were found by using this part from the R script Homoplasy_tau_theta_ABC.R:
Navascues <- read.table("tauNavascues.txt",header=F)
quantile(Navascues$V3,probs=c(0.025,0.975))

Were we found the upper and lower limits of the 95% confidence interval:
     2.5%     97.5% 
 1.731853 10.297377 

And those can be transformed into years, yielding these values:
Years <- (quantile(Navascues$V3,probs=c(0.025,0.975))/(2* u*L))*42.5
Years

     2.5%     97.5% 
 95589.32 568361.75 

To run the ABC algorithm, first create a list of random numbers using:

perl random_number.pl

Then, you can run the ABC algorithm using:

perl run_ABC.pl

And then, we can obtain the estimates of tau, MSH and DH using these lines of R code:

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

To get the confidence intervals for tau, MSH and DH values estimated using ABC, we simulated more than 1000 datasets using the demographic parameters estimated with ABC. This is done going into the ConfidenceIntervalsABC folder and running:

perl Confidence_intervals_simulations.pl

For each simulated dataset, we obtained a point estimate of tau, MSH and DH. From 1,000 estimates, we obtained the upper and lower limit of the 95% confidence intervals of tau, MSH and DH. Those values were:

## Tau ABC
> quantile (tau_ABC,probs=c(0.025,0.975))
     2.5%     97.5% 
 2.644644 11.004689 

## DH, MSH
> quantile (DH_estimate,probs=c(0.025,0.975))
     2.5%     97.5% 
0.1058740 0.4145667 
> 
> quantile (MSH_estimate,probs=c(0.025,0.975))
      2.5%      97.5% 
0.02600922 0.24357995 

## Expansion time in years
> (quantile(tau_ABC,probs=c(0.025,0.975))/(2* u*L))*42.5
    2.5%    97.5% 
145970.6 607401.7 

