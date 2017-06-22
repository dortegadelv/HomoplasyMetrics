$InputFile = $ARGV[0];
$OutputFile = $ARGV[1];
$LimitNumberOfDifferences = $ARGV[2];

open (INPUT,$InputFile ) or die "NO!";

@Haplotypes = ();

while(<INPUT>){

	chomp;
	$Line = $_;
	push(@Haplotypes,$Line);
	$Line =~ s/\t//gi;
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
		$HapLength = length($Haplotypes[0]);
		for ($l = 0; $l < $HapLength ; $l++){
			$SubstringOne = substr($Haplotypes[$j],$l,1);
			$SubstringTwo = substr($Haplotypes[$k],$l,1);
			if ($SubstringOne ne $SubstringTwo){
				$CurrentDiffNumber = $CurrentDiffNumber + 1;
			}
		}
		$NumberOfDifferences[$CurrentDiffNumber]++;
	}
}

open (OUTPUT,">$OutputFile") or die "NO!";

for ($i = 0; $i <= $LimitNumberOfDifferences; $i++){
print OUTPUT "$i\t$NumberOfDifferences[$i]\n";
}
