Simulations were created with:

perl Table_1_simulations.pl

Then, we created an .arb archive that will be used by the program Arlequin ( http://cmpg.unibe.ch/software/arlequin35/ ):

perl Arb_archive.pl

Then, we used the program Arlequin. We read the files “mismatch.arb” deposited inside each of the 10 “tau*” directories. Then we used the option “Estimate parameters of demographic expansion” from Arlequin.

Then, we parsed the files with:

perl homoplasy_tau.pl

Finally, we made the plot using the R script:

lineal_regression_homoplasy.R