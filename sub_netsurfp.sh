#!/bin/bash

HM="/home/projects/dtu_00009/people/varsha" 
## your home path where you want to have results
program_path="/services/tools/netsurfp/3.0"

logdir="$HM/netsurfp3_feature_batch2/log"
cshdir="$HM/netsurfp3_feature_batch2/csh"

mkdir -p $logdir
mkdir -p $cshdir

data_path="$HM/net_allergen_batch2"
result_path="$HM/netsurfp3_feature_batch2"


for file in `ls ${data_path}/*.fasta`
#while read p
do
    #prot_id=${file:0:5}
    prot_id=$(basename "$file")
    #prot_id=$p


        
    echo $prot_id
    # Options for queue system
    cscript=`mktemp $cshdir/csh.XXXXXX` || exit 1
    printf "#!/usr/bin/tcsh\n" >> $cscript
    printf "#PBS -W group_list=dtu_00009 -A dtu_00009\n" >> $cscript ##change to relevant group name that has permissions
    printf "#PBS -N netsurfp parallelization \n" >> $cscript
    ### allocate time and memory (do not go higher than 16gb as you will use an additional processor with double money charges) 
    printf "#PBS -l nodes=1:ppn=1:thinnode,mem=16gb,walltime=8:00:00\n" >> $cscript 
    printf "#PBS -d $logdir\n" >> $cscript
    printf "#PBS -o $prot_id.log\n" >> $cscript
    printf "#PBS -e $prot_id.err\n" >> $cscript
    printf "#PBS -N $prot_id\n" >> $cscript

    printf 'cd $PBS_O_WORKDIR\n' >> $cscript
    printf "module load tools\n" >> $cscript
    printf "module load anaconda3/2022.10\n" >> $cscript
    printf "module load perl\n" >> $cscript
    printf "module load netsurfp/3.0\n" >> $cscript
    ##printf "module load netmhciipan/4.0\n" >> $cscript

    printf "python $program_path/nsp3.py -m ${program_path}/models/nsp3.pth -i $file -o $result_path\n" >> $cscript

    printf "# EOF" >> $cscript

    qsub $cscript
    #break


done



