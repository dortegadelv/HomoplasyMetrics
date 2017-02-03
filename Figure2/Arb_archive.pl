for ($j=1;$j<=10;$j++){
    $tau=$j*0.025;
    $dir="tau".$tau;
    print "$dir\n";

    chdir("$dir");

open (ARB,">mismatch.arb") or die "Nel";
for ($i=1;$i<=200;$i++){
$archivo=$i.".arp";
print ARB "$archivo\n";
$archivo=$i."_infinite.arp";
print ARB "$archivo\n";
}
close (ARB);
    chdir("..");

}

