# Define input and output files
import glob

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
        "data/{sample}.fastq.gz"
    output:
        contigs = CONTIGS,
        scaffolds = "assembly/scaffolds.fasta",
    threads: 20
    shell:
        "spades.py -o assembly --careful -t {threads} --pe1-1 {input} --pe1-2 {input}"

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
