SGE_TASK_ID=1
RandomFile=$SGE_TASK_ID".random"
ExitFile="Set1/1."$SGE_TASK_ID".out"
echo $RandomFile
echo $ExitFile
../Programs/ABC/ABC 150 200000 -z 6 -eN tbs tbs -t tbs -Q -a 0.1 -seeds 1 1 $SGE_TASK_ID -A 10000 -H -C -R -K Set1/1.txt < $RandomFile > $ExitFile