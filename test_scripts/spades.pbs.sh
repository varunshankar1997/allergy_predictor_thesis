#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=co_23260 -A co_23260
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N spades
### Output files (comment out the next 2 lines to get the job name used instead)
#PBS -e spades.err
#PBS -o spades.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=40
### Memory
#PBS -l mem=185gb
### Requesting time - format is <days>:<hours>:<minutes>:<seconds> (here, 1 hour)
#PBS -l walltime=2:00:00:00
### The node reserved for course 23260
#PBS advres=co_23260.1633

# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR
 
### Here follows the user commands:
# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes
 
# Load all required modules for the job
module load tools
module load anaconda3/2021.05
module load spades/3.15.2 

# This is where the work is done
# Make sure that this script is not bigger than 64kb ~ 150 lines, otherwise put in seperat script and execute from here
id=ERR2597487
outDir="spades/$id"
mkdir -p $outDir

inDir=trim
timeDir=time
mkdir -p $timeDir

R1=${id}_1
R2=${id}_2

forward=$inDir/$R1.trim.fq.gz
reverse=$inDir/$R2.trim.fq.gz
singletons=$inDir/$id.singletons.fq.gz


threads=40
mem=185
cmd="/usr/bin/time -v -o $timeDir/spades.$id.time metaspades.py -t $threads -1 $forward -2 $reverse -s $singletons -k 27,47,67,87,107,127 --memory $mem -o $outDir"
echo "Doing $cmd"
$cmd
