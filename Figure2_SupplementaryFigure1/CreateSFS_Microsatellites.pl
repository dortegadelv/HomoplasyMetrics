$InputFile = $ARGV[0];
$OutputFile = $ARGV[1];
$LimitNumberOfDifferences = $ARGV[2];

open (INPUT,$InputFile ) or die "NO!";

@Haplotypes = ();

while(<INPUT>){

	chomp;
	$Line = $_;
	push(@Haplotypes,$Line);
	#	print "$Line\n";
	#	@SplitLine = split(//);
}

close(INPUT);
@NumberOfDifferences = ();
for ($i = 0; $i <= $LimitNumberOfDifferences; $i++){
	$NumberOfDifferences[$i] = 0;
}


for ($j = 0; $j <scalar(@Haplotypes) ; $j++){
	for ($k = $j+1; $k < scalar(@Haplotypes) ; $k++){
		$CurrentDiffNumber = 0;
		@Hap1Microsatellites = split(/\t/,$Haplotypes[$j]);
		@Hap2Microsatellites = split(/\t/,$Haplotypes[$k]);
		for ($l = 0; $l < scalar(@Hap1Microsatellites) ; $l++){
			$Difference = abs($Hap1Microsatellites[$l] - $Hap2Microsatellites[$l]);
			$CurrentDiffNumber = $CurrentDiffNumber + $Difference;
		}
#		print "$Haplotypes[$j]\n";
#		print "$Haplotypes[$k]\n";
#		print "$CurrentDiffNumber\n";
#		die "NO!";
		$NumberOfDifferences[$CurrentDiffNumber]++;
	}
}

open (OUTPUT,">$OutputFile") or die "NO!";

for ($i = 0; $i <= $LimitNumberOfDifferences; $i++){
print OUTPUT "$i\t$NumberOfDifferences[$i]\n";
}
