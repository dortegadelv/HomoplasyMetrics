@tau=();
@theta0=();
@theta1=();
@pvalue=();
@uptau01=();
@uptau05=();
@uptau1=();
@uptheta001=();
@uptheta005=();
@uptheta01=();
@uptheta101=();
@uptheta105=();
@uptheta11=();
@downtau01=();
@downtau05=();
@downtau1=();
@downtheta001=();
@downtheta005=();
@downtheta01=();
@downtheta101=();
@downtheta105=();
@downtheta11=();
@IS_tau=();
@IS_theta0=();
@IS_theta1=();
@IS_pvalue=();
@IS_uptau01=();
@IS_uptau05=();
@IS_uptau1=();
@IS_uptheta001=();
@IS_uptheta005=();
@IS_uptheta01=();
@IS_uptheta101=();
@IS_uptheta105=();
@IS_uptheta11=();
@IS_downtau01=();
@IS_downtau05=();
@IS_downtau1=();
@IS_downtheta001=();
@IS_downtheta005=();
@IS_downtheta01=();
@IS_downtheta101=();
@IS_downtheta105=();
@IS_downtheta11=();
@SHloc=();
@SH=();
@MASH=();
@SASH=();
@SHchanges=();
@SHdist=();
@HBC=();

open (MISMATCH,">homoplasy_tau.txt") or die "No lo puedo crear";
#print MISMATCH "Tau $va\n";
print MISMATCH "tau	theta0	theta1	pvalue	downtau(alpha=0.01)	uptau(alpha=0.01)	downtau(alpha=0.05)	uptau(alpha=0.05)	downtau(alpha=0.1)	uptau(alpha=0.1)	";
print MISMATCH "downtheta0(alpha=0.01)	uptheta0(alpha=0.01)	downtheta0(alpha=0.05)	uptheta0(alpha=0.05)	downtheta0(alpha=0.1)	uptheta0(alpha=0.1)	";
print MISMATCH "downtheta1(alpha=0.01)	uptheta1(alpha=0.01)	downtheta1(alpha=0.05)	uptheta1(alpha=0.05)	downtheta1(alpha=0.1)	uptheta1(alpha=0.1)";
print MISMATCH "	IS_tau	IS_theta0	IS_theta1	IS_pvalue	IS_downtau(alpha=0.01)	IS_uptau(alpha=0.01)	IS_downtau(alpha=0.05)	IS_uptau(alpha=0.05)	IS_downtau(alpha=0.1)	IS_uptau(alpha=0.1)	";
print MISMATCH "IS_downtheta0(alpha=0.01)	IS_uptheta0(alpha=0.01)	IS_downtheta0(alpha=0.05)	IS_uptheta0(alpha=0.05)	IS_downtheta0(alpha=0.1)	IS_uptheta0(alpha=0.1)	";
print MISMATCH "IS_downtheta1(alpha=0.01)	IS_uptheta1(alpha=0.01)	IS_downtheta1(alpha=0.05)	IS_uptheta1(alpha=0.05)	IS_downtheta1(alpha=0.1)	IS_uptheta1(alpha=0.1)";
print MISMATCH "	MSH	SH	MASH	P	SHchanges	DH	HBC\n";

for($k=1;$k<=10;$k++){
$folder=$k*0.025;
$folder="tau".$folder;
print "$folder\n";
chdir($folder);
for($j=1;$j<=100;$j++){
$microarlequin=$j.".res";
print "$microarlequin	";
chdir($microarlequin);
$archivo = $j.".htm";
$bandera01=0;
$bandera05=0;
$bandera1=0;
open(MICRO,"$archivo") or die "No puedo abrir el archivo $archivo";
while(<MICRO>){

if(/^Tau\s+:\s+(\d+)\.(\d+)/){
$temp="$1".".$2";
$tau[$j]=$temp;
#print "$temp";
}

if(/^Theta0\s+:\s+(\d+)\.(\d+)/){
$temp="$1".".$2";
$theta0[$j]=$temp;
}

if(/^Theta1\s+:\s+(\d+)\.(\d+)/){
$temp="$1".".$2";
$theta1[$j]=$temp;
}

if(/^\s+P\(Sim\. Ssd \>\= Obs\. Ssd\):\s+(\d+)\.(\d+)/){
$temp="$1".".$2";
$pvalue[$j]=$temp;

}

if(/Confidence intervals \(Percentile method\):	 alpha=	0.010/){
$bandera01 = 1;
}

if(/Confidence intervals \(Percentile method\):	 alpha=	0.050/){
$bandera05 = 1;
}

if(/Confidence intervals \(Percentile method\):	 alpha=	0.100/){
$bandera1 = 1;
}

if(/Tau:\s+\d+\.\d+\s+(\d+)\.(\d+)\s+(\d+)\.(\d+)/){
$temp="$1".".$2";
$temp2="$3".".$4";
if($bandera01==1){
$downtau01[$j]=$temp;
$uptau01[$j]=$temp2;
}
if($bandera05==1){
$downtau05[$j]=$temp;
$uptau05[$j]=$temp2;
}
if($bandera1==1){
$downtau1[$j]=$temp;
$uptau1[$j]=$temp2;
}
}
if(/Theta0:\s+\d+\.\d+\s+(\d+)\.(\d+)\s+(\d+)\.(\d+)/){
$temp="$1".".$2";
$temp2="$3".".$4";
if($bandera01==1){
$downtheta001[$j]=$temp;
$uptheta001[$j]=$temp2;
}
if($bandera05==1){
$downtheta005[$j]=$temp;
$uptheta005[$j]=$temp2;
}
if($bandera1==1){
$downtheta01[$j]=$temp;
$uptheta01[$j]=$temp2;
}
}
if(/Theta1:\s+\d+\.\d+\s+(\d+)\.(\d+)\s+(\d+)\.(\d+)/){
$temp="$1".".$2";
$temp2="$3".".$4";
if($bandera01==1){
$downtheta101[$j]=$temp;
$uptheta101[$j]=$temp2;
$bandera01=0;
}
if($bandera05==1){
$downtheta105[$j]=$temp;
$uptheta105[$j]=$temp2;
$bandera05=0;
}
if($bandera1==1){
$downtheta11[$j]=$temp;
$uptheta11[$j]=$temp2;
$bandera1=0;
}
}
}
close(MICRO);
chdir("..");
}

for($j=1;$j<=100;$j++){
$microarlequin=$j."_infinite.res";
print "$microarlequin	";
chdir($microarlequin);
$archivo = $j."_infinite.htm";
$bandera01=0;
$bandera05=0;
$bandera1=0;
open(MICRO,"$archivo") or die "No puedo abrir el archivo $archivo";
while(<MICRO>){

if(/^Tau\s+:\s+(\d+)\.(\d+)/){
$temp="$1".".$2";
$IS_tau[$j]=$temp;
#print "$temp";
}

if(/^Theta0\s+:\s+(\d+)\.(\d+)/){
$temp="$1".".$2";
$IS_theta0[$j]=$temp;
}

if(/^Theta1\s+:\s+(\d+)\.(\d+)/){
$temp="$1".".$2";
$IS_theta1[$j]=$temp;
}

if(/^\s+P\(Sim\. Ssd \>\= Obs\. Ssd\):\s+(\d+)\.(\d+)/){
$temp="$1".".$2";
$IS_pvalue[$j]=$temp;

}

if(/Confidence intervals \(Percentile method\):	 alpha=	0.010/){
$bandera01 = 1;
}

if(/Confidence intervals \(Percentile method\):	 alpha=	0.050/){
$bandera05 = 1;
}

if(/Confidence intervals \(Percentile method\):	 alpha=	0.100/){
$bandera1 = 1;
}

if(/Tau:\s+\d+\.\d+\s+(\d+)\.(\d+)\s+(\d+)\.(\d+)/){
$temp="$1".".$2";
$temp2="$3".".$4";
if($bandera01==1){
$IS_downtau01[$j]=$temp;
$IS_uptau01[$j]=$temp2;
}
if($bandera05==1){
$IS_downtau05[$j]=$temp;
$IS_uptau05[$j]=$temp2;
}
if($bandera1==1){
$IS_downtau1[$j]=$temp;
$IS_uptau1[$j]=$temp2;
}
}
if(/Theta0:\s+\d+\.\d+\s+(\d+)\.(\d+)\s+(\d+)\.(\d+)/){
$temp="$1".".$2";
$temp2="$3".".$4";
if($bandera01==1){
$IS_downtheta001[$j]=$temp;
$IS_uptheta001[$j]=$temp2;
}
if($bandera05==1){
$IS_downtheta005[$j]=$temp;
$IS_uptheta005[$j]=$temp2;
}
if($bandera1==1){
$IS_downtheta01[$j]=$temp;
$IS_uptheta01[$j]=$temp2;
}
}
if(/Theta1:\s+\d+\.\d+\s+(\d+)\.(\d+)\s+(\d+)\.(\d+)/){
$temp="$1".".$2";
$temp2="$3".".$4";
if($bandera01==1){
$IS_downtheta101[$j]=$temp;
$IS_uptheta101[$j]=$temp2;
$bandera01=0;
}
if($bandera05==1){
$IS_downtheta105[$j]=$temp;
$IS_uptheta105[$j]=$temp2;
$bandera05=0;
}
if($bandera1==1){
$IS_downtheta11[$j]=$temp;
$IS_uptheta11[$j]=$temp2;
$bandera1=0;
}
}
}
close(MICRO);
chdir("..");
}

for($j=1;$j<=100;$j++){
$homoplasy= $j."homoplasy.txt";
open (HOM,$homoplasy) or die "NO";
while (<HOM>){
if (/^(\d+)\.(\d+)\t(\d+)\.(\d+)\t(\d+)\.(\d+)\t(\d+)\.(\d+)\t(\d+)\.(\d+)\t(\d+)\.(\d+)\t(\d+)\.(\d+)/){
$SHloc[$j]=$1.".$2";
$SH[$j]=$3.".$4";
$MASH[$j]=$5.".$6";
$SASH[$j]=$7.".$8";
$SHchanges[$j]=$9.".$10";
$SHdist[$j]=$11.".$12";
$HBC[$j]=$13.".$14";
}
}
}
chdir("..");
for($j=1;$j<=100;$j++){
print MISMATCH "$tau[$j]	$theta0[$j]	$theta1[$j]	$pvalue[$j]	$downtau01[$j]	$uptau01[$j]	$downtau05[$j]	$uptau05[$j]	$downtau1[$j]	$uptau1[$j]	";
print MISMATCH "$downtheta001[$j]	$uptheta001[$j]	$downtheta005[$j]	$uptheta005[$j]	$downtheta01[$j]	$uptheta01[$j]	";
print MISMATCH "$downtheta101[$j]	$uptheta101[$j]	$downtheta105[$j]	$uptheta105[$j]	$downtheta11[$j]	$uptheta11[$j]	";
print MISMATCH "$IS_tau[$j]	$IS_theta0[$j]	$IS_theta1[$j]	$IS_pvalue[$j]	$IS_downtau01[$j]	$IS_uptau01[$j]	$IS_downtau05[$j]	$IS_uptau05[$j]	$IS_downtau1[$j]	$IS_uptau1[$j]	";
print MISMATCH "$IS_downtheta001[$j]	$IS_uptheta001[$j]	$IS_downtheta005[$j]	$IS_uptheta005[$j]	$IS_downtheta01[$j]	$IS_uptheta01[$j]	";
print MISMATCH "$IS_downtheta101[$j]	$IS_uptheta101[$j]	$IS_downtheta105[$j]	$IS_uptheta105[$j]	$IS_downtheta11[$j]	$IS_uptheta11[$j]	";
print MISMATCH "$SHloc[$j]	$SH[$j]	$MASH[$j]	$SASH[$j]	$SHchanges[$j]	$SHdist[$j]	$HBC[$j]\n";
}

}

close (MISMATCH);
