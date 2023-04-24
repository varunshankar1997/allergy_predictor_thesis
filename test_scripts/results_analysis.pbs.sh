#!/bin/bash
### Note: No commands may be executed until after the #PBS lines
### Account information
###PBS -W group_list=co_23260 -A co_23260
### Job name (comment out the next line to get the name of the script used as the job name)
#PBS -N MMSEQS2
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
module load prodigal/2.6.2
module load mmseqs2/release_14-7e284
# This is where the work is done
# Make sure that this script is not bigger than 64kb ~ 150 lines, otherwise put in seperat script and execute from here

mem=185
cmd="python3 results_single_isolate.py"
echo "Doing $cmd"
$cmd
