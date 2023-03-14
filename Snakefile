# Define input and output files
import glob


#loading the right modules

module load anaconda3/2021.05
module load spades/3.15.2

#code to extract id numbers from
path_fastq_sequenced = "/home/projects/dtu_00009/people/askerb/DIABIMMUNE/*_pe_*"

test_li = []
id_list =[]
for file in glob.glob(path_fastq_sequenced):
  test_li.append(file.strip())
  x = file[50:56]
  id_list.append(x)



id_list = list(set(id_list))
samples = id_list

#directory of the paired fastq files


CONTIGS = "assembly/contigs.fasta"
PROTEINS = "proteins/proteins.faa"
SIGNALP_OUTPUT = "signalp/signalp.out"

# Define rule to run SPAdes
rule spades:
    input:
        "data/{sample}_pe_1.fastq.gz"
        "data/{sample}_pe_2.fastq.gz"
    output:
        contigs = CONTIGS,
        scaffolds = "assembly/{sample}/scaffolds.fasta",
    threads: 40
    shell:
        "metaspades.py -t {threads} -1 {input[0]} -2 {input[1]} -k 27,47,67,87,107,127 --memory -o {output.scaffolds} "

# Define rule to run Prodigal for gene prediction
rule prodigal:
    input:
        contigs = CONTIGS,
    output:
        proteins = PROTEINS,
    shell:
        "prodigal -i {input.contigs} -a {output.proteins}"

# Define rule to run SignalP for protein sequence prediction
rule signalp:
    input:
        proteins = PROTEINS,
    output:
        SIGNALP_OUTPUT,
    shell:
        "signalp -t euk -f short -m mature {input.proteins} > {output}"
