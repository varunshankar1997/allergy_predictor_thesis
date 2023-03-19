
##path = "/home/projects/dtu_00009/people/varsha/spades_test2/scaffolds.fasta"
##input = "G80594"
##outpath = "/home/projects/dtu_00009/people/varsha/spades_test2/scaffold21s.fasta"

import argparse

# Create argument parser
parser = argparse.ArgumentParser(description="Add ID to FASTA file header")
parser.add_argument("-i", "--input", dest="fasta_file", type=str, required=True, help="Input FASTA file name")
parser.add_argument("-seq", "--sequence_id", dest="seq_id", type=str, required=True, help="Sequence ID to add to header")

# Parse command line arguments
args = parser.parse_args()

# Open input file
with open(args.fasta_file, "r+") as infile:
    # Loop through each line in the file
    for i, line in enumerate(infile):
        if line.startswith(">"):
            line = ">" + args.seq_id + "_" + line[1:]  # Add sequence ID to head of sequence
            # Write modified line back to file
            infile.seek(0)
            infile.write(line)
            infile.seek(0, 2)
            if i == 0:
                infile.write("\n")  # Add newline after first header

# No output file is created, the input file is updated in place

