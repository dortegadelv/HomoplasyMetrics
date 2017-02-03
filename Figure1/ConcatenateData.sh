Tau[1]="tau0.025"
Tau[2]="tau0.05"
Tau[3]="tau0.075"
Tau[4]="tau0.1"
Tau[5]="tau0.125"
Tau[6]="tau0.15"
Tau[7]="tau0.175"
Tau[8]="tau0.2"
Tau[9]="tau0.225"
Tau[10]="tau0.25"

rm ConcatenatedDataStepwiseCoalModel.txt

for i in {1..10}
do
tail -n1 Results/${Tau[$i]}/{1..100}homoplasy.txt | grep -v '==' | grep '.' >> ConcatenatedDataStepwiseCoalModel.txt
done
