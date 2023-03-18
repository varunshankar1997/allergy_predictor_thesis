import glob


#loading the right modules

module load anaconda3/2021.05
module load spades/3.15.2
module load prodigal/2.6.2
module load signalp/6.0g


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
        scaffolds = "assembly/{sample}/scaffolds.fasta" ,
    output:
        proteins = "proteins/{sample}",
    shell:
        "prodigal -i {input.scaffolds} -o {output.proteins}/genes -a {output.proteins}/{sample}.fasta -p meta"

# Define rule to run SignalP for protein sequence prediction
rule signalp:
    input:
        protein = "proteins/{sample}/{sample}.fasta",
    output:
        SIGNALP_OUTPUT = ,
    shell:
        "signalp6 --fastafile {input.protein} --organism other --output_dir signalp_out/{sample}  --format txt --mode fast"
