Tau[1]="2"
Tau[2]="3"
Tau[3]="4"
Tau[4]="5"
Tau[5]="6"
Tau[6]="7"
Tau[7]="8"
Tau[8]="9"
Tau[9]="10"

rm ConcatenatedData.txt

for i in {1..9}
do
tail -n1 ${Tau[$i]}/{1..100}homoplasy.txt | grep -v '==' | grep '.' >> ConcatenatedData.txt
done
