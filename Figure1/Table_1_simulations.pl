### The program msHOT (which is a modification of the original msHOT by Hellenthal and Stephens, 2007, Bioinformatics) creates the simulation data. All the options are the same as that of the original ms (Hudson, 2002, Bioinformatics) and msHOT. The flag -Q must be used to generate microsatellites. The flag -z 6 indicates that 6 microsatellites will be generated. The value of theta_1 (30) given by the option -t is equal to 2*L*N1*mu, where L is the number of microsatellites, mu is the mutation rate per generation per microsatellite, N1 is the effective population size in the present. 100 simulations were performed for each value of tau. The number of linked haplotypes with microsatellites per simulation was equal to 150.


# chdir("..");
chdir("Results");
for ($i=1;$i<=10;$i++){
	$tau=$i*0.025;
	$dir="tau".$tau;
	print "$dir\n";
	system("mkdir $dir");
	chdir("$dir");
#	system("gcc -o msGCHOT msGCHOT.c streecGCHOT.c rand1.c -lm");
	system("../../../Programs/msHOT-derivedSSRSimulator/msHOT 150 100 -t 30 -eN $tau 0.001 -Q -z 6 -seeds 1 2 5");
	chdir("..");
}
