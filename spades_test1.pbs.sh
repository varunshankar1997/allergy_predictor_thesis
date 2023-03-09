#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
###PBS -W group_list=co_23260 -A co_23260
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
###PBS advres=co_23260.1633

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

mem=185
cmd=" metaspades.py -t 20 -1 /home/projects/dtu_00009/people/askerb/DIABIMMUNE/G80594_pe_1.fastq.gz  -2 /home/projects/dtu_00009/people/askerb/DIABIMMUNE/G80594_pe_2.fastq.gz  -k 27,47,67,87,107,127 --memory $mem -o /home/projects/dtu_00009/people/varsha/spades_test2"
echo "Doing $cmd"
$cmd
