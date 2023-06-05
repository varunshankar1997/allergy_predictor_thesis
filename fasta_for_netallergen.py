"""

def extract_matching_sequences(file_names, fasta_file_path, output_file_path):
    # Open input and output files
    with open(fasta_file_path, 'r') as input_file, open(output_file_path, 'w') as output_file:
        current_header = ''
        current_sequence = ''
        for line in input_file:
            line = line.strip()
            if line.startswith('>'):
                # Check if the current header matches any file name
                current_header = line[1:]
                if any(file_name in current_header for file_name in file_names):
                    # Write the header and sequence to the output file
                    output_file.write('>' + current_header + '\n' + current_sequence + '\n')
                
                current_sequence = ''
            else:
                current_sequence += line

        # Write the last header and sequence if it matches any file name
        if any(file_name in current_header for file_name in file_names):
            output_file.write('>' + current_header + '\n' + current_sequence + '\n')
"""
import gzip 
# Example usage
fasta_file_path = 'ELGP_95.faa.gz'
output_file_path = 'netallergen_input.fasta'
fasta_file_path1 = 'protein_test.fasta'
fasta_file ='ELGP_95.fasta'
output_file_path2 = 'demo.fasta'
with open('matching_species.txt', 'r') as file:
    file_names = file.read().splitlines()


def filter_fasta(input_file, output_file, headers_to_match):
    with open(input_file, 'r') as f_in, open(output_file, 'w') as f_out:
        write_entry = False
        for line in f_in:
            if line.startswith('>'):
                header = line[1:].split(' ',1)[0].strip()
                if header in headers_to_match:
                    write_entry = True
                    f_out.write(line)
                else:
                    write_entry = False
            elif write_entry:
                f_out.write(line)
            

# Example usage


filter_fasta(fasta_file,output_file_path ,file_names)
