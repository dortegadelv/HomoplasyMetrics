Follow the info on the Homoplasy_tau_theta_ABC_color.R points to the location of the files. Files are in
/Users/vicentediegoortegadelvecchyo/Documents/Pinero/Articulo_homoplasia/Articulo/Simulaciones_articulo/HoffmanClusterSimulations/Merge_Set_1_2_3_4_ordenados/

The files for each set were created using this for set 1:
/Users/vicentediegoortegadelvecchyo/Documents/Pinero/Articulo_homoplasia/Articulo/Simulaciones_articulo/Experiment_2/Set_1/simulations_generation.pl
And set 2, 3 and 4 are:
/Users/vicentediegoortegadelvecchyo/Documents/Pinero/Articulo_homoplasia/Articulo/Simulaciones_articulo/Experiment_2/Results_with_10000_sims/simulations_generation.pl

To prove that the microsatellite files generated in:
/Users/vicentediegoortegadelvecchyo/Documents/Pinero/Articulo_homoplasia/Articulo/Simulaciones_articulo/HoffmanClusterSimulations/Merge_Set_1_2_3_4_ordenados/
are identical to:
/Users/vicentediegoortegadelvecchyo/Documents/Pinero/Articulo_homoplasia/Articulo/Simulaciones_articulo/Experiment_2/Set_{1,2,3,4}/
I used the script /Users/vicentediegoortegadelvecchyo/Documents/Pinero/Articulo_homoplasia/Articulo/Simulaciones_articulo/HoffmanClusterSimulations/Merge_Set_1_2_3_4_ordenados/CompareFilesOnDifferentPlaces.pl

And to prove that the ABC runs in /Users/vicentediegoortegadelvecchyo/Documents/Pinero/Articulo_homoplasia/Articulo/Simulaciones_articulo/HoffmanClusterSimulations/Merge_Set_1_2_3_4_ordenados/
are identical to /Users/vicentediegoortegadelvecchyo/Documents/Pinero/Articulo_homoplasia/Articulo/Simulaciones_articulo/HoffmanClusterSimulations/Merge_Set_1_2_3_4/
Also used /Users/vicentediegoortegadelvecchyo/Documents/Pinero/Articulo_homoplasia/Articulo/Simulaciones_articulo/HoffmanClusterSimulations/Merge_Set_1_2_3_4_ordenados/CompareFilesOnDifferentPlaces.pl

All files contain 10,000 accepted simulations done by ABC. The files were concatenated with ParseOutfilesToBigfile.pl

To run the ABC analysis use 
/Users/vicentediegoortegadelvecchyo/Documents/Pinero/Articulo_homoplasia/Articulo/Simulaciones_articulo/HoffmanClusterSimulations/Merge_Set_1_2_3_4/ArchivoCorredorABC{1..400}.sh

The random numbers were created using:
/Users/vicentediegoortegadelvecchyo/Documents/Pinero/Articulo_homoplasia/Articulo/Simulaciones_articulo/HoffmanClusterSimulations/Merge_Set_1_2_3_4/randomnumber.sh
and were separated using:
/Users/vicentediegoortegadelvecchyo/Documents/Pinero/Articulo_homoplasia/Articulo/Simulaciones_articulo/HoffmanClusterSimulations/Merge_Set_1_2_3_4/ParseRandomNumber.sh
To separate the files from randomnumber.txt the file ParseRandomNumber.sh calls ParseRandomNumber.pl. In the file ParseRandomNumber.pl you need to erase the last line to make things work.

On August 24, 2014 I made a small test to re-create the file 1.1.out to make sure that everything is ok on Hoffman2. Results are in: 
/u/home/d/diegoort/project/Homoplasy/OldABC_RetryAnalysis
Everything was fine and results are reproducible :)

