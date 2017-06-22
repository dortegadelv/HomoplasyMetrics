for ($i=1;$i<=10;$i++){
	$tau=$i*0.025;
	$dir="tau".$tau;
	print "$dir\n";
    mkdir $dir;
	chdir("$dir");
	system("../../Programs/msHOT-derivedSSRSimulator/msHOT 150 200 -t 30 -eN $tau 0.001 -Q -z 6 -seeds 1 2 3");
	chdir("..");
}
#-eN tbs 0.001