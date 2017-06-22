@Sums = ();

for ($i = 0; $i <=100; $i++){
    $Sums = 0;
}
$OutputFile = "OutputTotalSum.txt";
open (OUTPUT,">$OutputFile") or die "NO!";

for ($i = 1; $i <=100; $i++){
$InputFile = "SimsToCheck/SFSInfinite_Case".$i.".txt";
open (INPUT,$InputFile) or die "NO! $InputFile";
    while (<INPUT>){
        chomp;
        $Line = $_;
        @SplitLine = split(/\s+/,$Line);
        $Sums[$SplitLine[0]] = $Sums[$SplitLine[0]] + $SplitLine[1];
    }
    
    close(INPUT);
}

for ($i = 0; $i <=100; $i++){
    print OUTPUT "$i\t$Sums[$i]\n";
}
close (OUTPUT)