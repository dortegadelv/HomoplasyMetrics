for ($i = 1; $i <= 100; $i++){
    $SGE_TASK_ID=$i;
    $ABCRunningFiles="ABCRunningFiles/RunABCFile".$i.".txt";
    open (ABC,">$ABCRunningFiles") or die "No";
    print ABC "
RandomFile=\../$SGE_TASK_ID\".random\"
ExitFile=\"../Set1/$i.\"\$SGE_TASK_ID\".out\"
echo \$RandomFile
echo \$ExitFile
../Programs/ABC/ABC 150 200000 -z 6 -eN tbs tbs -t tbs -Q -a 0.1 -seeds 1 1 $SGE_TASK_ID -A 10000 -H -C -R -K ../Set1/$i.txt < \$RandomFile > \$ExitFile";
    close(ABC);
}

for ($i = 1; $i <= 100; $i++){
    $SGE_TASK_ID=$i;
    $Sum=100+$i;
    $ABCRunningFiles="ABCRunningFiles/RunABCFile".$Sum.".txt";
    open (ABC,">$ABCRunningFiles") or die "No";
    print ABC "
    RandomFile=\../$SGE_TASK_ID\".random\"
    ExitFile=\"../Set2/$i.\"\$SGE_TASK_ID\".out\"
    echo \$RandomFile
    echo \$ExitFile
    ../Programs/ABC/ABC 150 200000 -z 6 -eN tbs tbs -t tbs -Q -a 0.1 -seeds 1 1 $SGE_TASK_ID -A 10000 -H -C -R -K ../Set2/$i.txt < \$RandomFile > \$ExitFile";
    close(ABC);
}

for ($i = 1; $i <= 100; $i++){
    $SGE_TASK_ID=$i;
    $Sum=200+$i;
    $ABCRunningFiles="ABCRunningFiles/RunABCFile".$Sum.".txt";
    open (ABC,">$ABCRunningFiles") or die "No";
    print ABC "
    RandomFile=\../$SGE_TASK_ID\".random\"
    ExitFile=\"../Set3/$i.\"\$SGE_TASK_ID\".out\"
    echo \$RandomFile
    echo \$ExitFile
    ../Programs/ABC/ABC 150 200000 -z 6 -eN tbs tbs -t tbs -Q -a 0.1 -seeds 1 1 $SGE_TASK_ID -A 10000 -H -C -R -K ../Set3/$i.txt < \$RandomFile > \$ExitFile";
    close(ABC);
}

for ($i = 1; $i <= 100; $i++){
    $SGE_TASK_ID=$i;
    $Sum=300+$i;
    $ABCRunningFiles="ABCRunningFiles/RunABCFile".$Sum.".txt";
    open (ABC,">$ABCRunningFiles") or die "No";
    print ABC "
    RandomFile=\../$SGE_TASK_ID\".random\"
    ExitFile=\"../Set4/$i.\"\$SGE_TASK_ID\".out\"
    echo \$RandomFile
    echo \$ExitFile
    ../Programs/ABC/ABC 150 200000 -z 6 -eN tbs tbs -t tbs -Q -a 0.1 -seeds 1 1 $SGE_TASK_ID -A 10000 -H -C -R -K ../Set4/$i.txt < \$RandomFile > \$ExitFile";
    close(ABC);
}
