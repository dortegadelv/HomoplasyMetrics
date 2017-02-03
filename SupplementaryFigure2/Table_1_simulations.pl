for ($i=1;$i<=10;$i++){
	$tau=$i*0.0125;
	$dir="tau".$tau;
	print "$dir\n";
	system("mkdir $dir");
	chdir("$dir");
#	system("gcc -o msGCHOT msGCHOT.c streecGCHOT.c rand1.c -lm");
	system("../../Programs/msHOT-derivedSSRSimulator/msHOT 150 200 -t 60 -eN $tau 0.001 -Q -z 6 -seeds 1 2 3");
	chdir("..");
}
#-eN tbs 0.001