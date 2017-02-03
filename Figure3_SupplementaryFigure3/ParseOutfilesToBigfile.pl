for ($k =1; $k <= 4; $k++){
    $Folder= "Set".$k."/";
for ($j =1; $j <= 100; $j++){
    $File = $Folder.$j.".out";
open (RES, ">$File") or die "NO";
$TotalLines=0;
	print "$j\n";
for ($i = 1;$i<=10000; $i++){
    $ExitFile = $Folder.$j.$i.".out";
	$Archive = "$j".".$i".".out";
	open (ARC, $ExitFile) or die "Naranjas! $Archive";
	while (<ARC>){
		last if ($TotalLines >= 10000);
		if (/^Acceptancenum/){
			if ($i == 1){
				print RES $_;
			}
		}else {
			print RES "$_";
			#	print "$TotalLines ";
			$TotalLines++;
			#	print "$TotalLines ";
		}
	}
	last if ($TotalLines >= 10000);
}
}
}
