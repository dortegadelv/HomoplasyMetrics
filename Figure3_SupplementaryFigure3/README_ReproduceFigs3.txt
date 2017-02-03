To generate the files from Set 1, use:

perl simulations_generationSetOne.pl

And to generate the files from Set 2, 3 and 4, use:

perl simulations_generationSet234.pl

To run the ABC analysis, we ran the script randomnumber.sh to generate a list of random numbers. We ran that script using this command from randomnumber.sh:

../Programs/RandomNumbers/randnumb 500000000 -0 0 0.01 -1 0 200 -t 0 1 -r 2

Options of the program randnumb: 1) -0 0 0.01 Indicates that the prior distribution for the reduction from Theta_1 to Theta_0 follows a uniform distribution that goes from 0 to 0.01. The value sampled from the uniform distribution (0,0.01) is multiplied by Theta_1 to obtain the value of Theta_0.
2) -1 0 200 The prior distribution of Theta_1 is a uniform distribution (0,200)
3) -t 0 1 The prior distribution for Tau. This is a uniform distribution (0,2*(sampled value of Theta_1) * 1).
4) -r 2 . random seed number.

Then, I separated the list of random numbers randomnumber.txt using the script ParseRandomNumber.sh

After creating the Random numbers file, we ran the ABC algorithm using the 400 files located in ABCRunningFiles. Each of the RunABCFile*.txt files can be run by changing the variable SGE_TASK_ID to any number from 1 to 2500. Each time you run the RunABCFile*.txt files, an exit file with the *.out suffix will be printed. Each row below the header belongs to one of the accepted simulations. After we obtain 10,000 acceptances by running each of the RunABCFile*.txt many times with different SGE_TASK_ID values starting from 1 in ascending order, we stop running the RunABCFile*.txt files.

The ABC algorithm is ran using a command line that follows this syntax:
../Programs/ABC/ABC 150 200000 -z 6 -eN tbs tbs -t tbs -Q -a 0.1 -seeds 1 1 82 -A 10000 -H -C -R -K ../Set4/82.txt < $RandomFile > $ExitFile

where: 
150 number of haplotypes simulated
200000 - number of simulations performed
-z 6 is the number of micro satellites
-eN and -t are parameters that follow the same syntax as msHOT.
-Q This is a flag indicating that we will use an ABC rejection algorithm. Always use this flag.
-a Tolerance. See step 5) of the ABC algorithm in the paper.
-seeds Same parameter as in msHOT.
-A number of accepted simulations wanted.
-H -C -R leave the options as they are. They are related to the summary statistics used.
-K File with the microsatellite data.

After you have ran enough simulations, you can concatenate the results for each file. This can be done using the ParseOutfilesToBigfile.pl script:

perl ParseOutfilesToBigfile.pl

All files contain 10,000 accepted simulations done by ABC.

The ABC results for the 400 files are located in:

Results/Set1
Results/Set2
Results/Set3
Results/Set4
 
I also copied the *homoplasy.txt files that come from running simulations_generationSetOne.pl over there.

Finally, I used the script Homoplasy_tau_theta_ABC_color.R to do the plots Figure3.pdf and SuppFigure3.pdf . One important thing to do is to change where the function setwd() points, according to which *.out files you want to take from a particular set.
