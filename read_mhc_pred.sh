#!/bin/bash

HM="/home/projects/dtu_00009/people/varsha" ## your home path where you want to have results
NETMHCIIpan="/home/projects/vaccine/people/morni/netMHCIIpan-4.2/netMHCIIpan"


SEQ_folder= "$HM/mhciipan_extend-5_full/results/pred" #path to mhciipan predictions

result_dir="$HM/net_allergen_batch2/feature_files"



for file in `ls $SEQ_folder`
do
    prot_id=$file

    # Print check 
    printf "sending $prot_id\t for prediction\n"

    # Options for queue system
    #echo '#\!/bin/csh' > test.$allele_name.$prot_id.csh
    cscript=`mktemp $cshdir/$prot_id.csh.XXXXXX` || exit 1
    printf "#\!/usr/bin/tcsh\n" > $cscript
    printf "#PBS -W group_list=dtu_00009 -A dtu_00009\n" >> $cscript
    ### allocate time and memory (do not go higher than 16gb as you will use an additional processor with double money charges)
    printf "#PBS -l nodes=1:ppn=1:thinnode,mem=16gb,walltime=1:59:00\n" >> $cscript 
    printf "#PBS -d $logdir\n" >> $cscript
    printf "#PBS -o $prot_id.log\n" >> $cscript
    printf "#PBS -e $prot_id.err\n" >> $cscript
    printf "#PBS -N $prot_id\n" >> $cscript
    
    # Run NetMCHpan call
    printf 'cd $PBS_O_WORKDIR\n' >> $cscript
    printf "module load tools\n" >> $cscript
    printf "module load anaconda3/2022.10\n" >> $cscript
    printf "module load perl\n" >> $cscript
    printf "module load netmhciipan/4.2a\n" >> $cscript
    printf "python /home/projects/dtu_00009/people/varsha/NetAllergen_modded/src/mhciibinder.py  -i $SEQ_folder/$file -a /home/projects/dtu_00009/people/varsha/NetAllergen-1.0/data/7alleles.txt -o $result_dir/$file.csv\n" >> $cscript
    #printf "/services/tools/netmhciipan/4.2a/netMHCIIpan -a DRB1_0401,HLA-DQA10201-DQB10202,HLA-DQA10401-DQB10301,HLA-DQA10103-DQB10601,HLA-DQA10501-DQB10201,HLA-DQA10301-DQB10302,DRB1_1501 -context -termAcon -f  $SEQ_folder/$file  -xls -xlsfile  $result_dir/pred.$file.$allele > /dev/null\n" >> $cscript
    #done < $ALLELELIST
	
	
    printf "# EOF" >> $cscript
    
    
    qsub $cscript
    #break

    #break


done
