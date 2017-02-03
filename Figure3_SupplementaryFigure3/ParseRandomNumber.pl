open (RAN,"randomnumber.txt") or die "NO";
$line=1;
$ArchiveNumber = 1;
$Archive = $ArchiveNumber.".random";
open (ARC,">$Archive") or die "NO!";
while (<RAN>){
	$mod = $line % 200000;
	#	print $mod;
	if (/(.+)/){
	if ($mod == 0){
		print "Hi!";
		print ARC "$1\n";
		close (ARC);
		$ArchiveNumber++;
		print "$ArchiveNumber\n";
		$Archive = $ArchiveNumber.".random";
		open (ARC,">$Archive") or die "NO!";
		$line++;
	}else{
		print ARC "$1\n";
		$line++;
	}
}
}
close (ARC);
system ("rm $Archive")
