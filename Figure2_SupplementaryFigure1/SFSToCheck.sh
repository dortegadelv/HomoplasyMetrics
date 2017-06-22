# perl CreateSFS_InfiniteSites.pl tau0.075/infinite37.txt SFSInfinite_Case1.txt 100
# perl CreateSFS_InfiniteSites.pl tau0.075/infinite97.txt SFSInfinite_Case2.txt 100
# perl CreateSFS_InfiniteSites.pl tau0.225/infinite38.txt SFSInfinite_Case3.txt 100
# perl CreateSFS_InfiniteSites.pl tau0.25/infinite55.txt SFSInfinite_Case4.txt 100
# perl CreateSFS_Microsatellites.pl tau0.075/37.txt SFSMic_Case1.txt 100
# perl CreateSFS_Microsatellites.pl tau0.075/97.txt SFSMic_Case2.txt 100
# perl CreateSFS_Microsatellites.pl tau0.225/38.txt SFSMic_Case3.txt 100
# perl CreateSFS_Microsatellites.pl tau0.25/55.txt SFSMic_Case4.txt 100

for i in {1..100}
do
InputFile="tau0.25/infinite"$i".txt"
OutputFile="SimsToCheck/SFSInfinite_Case"$i".txt"
perl CreateSFS_InfiniteSites.pl $InputFile $OutputFile 100

done