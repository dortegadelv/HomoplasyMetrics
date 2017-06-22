#system("gcc -o msGCHOT msGCHOT.c streecGCHOT.c rand1.c -lm");
for ($i=2;$i<=10;$i++){
	$tau=3/(($i*5)*2);
	$dir="tau".$tau;
    $Theta = 5 * $i;
	print "$dir\n";
    system("mkdir $i");
	chdir("$i");
    print "../../Programs/msHOT-derivedSSRSimulator/msHOT 150 100 -t $Theta -eN 0.1 0.001 -Q -z $i -seeds 1 2 $i";
	system("../../Programs/msHOT-derivedSSRSimulator/msHOT 150 100 -t $Theta -eN 0.1 0.001 -Q -z $i -seeds 1 2 $i");
	chdir("..");
}
#-eN tbs 0.001