with open("ELGP_95.faa.gz", 'r') as input_file, open("output_file_path.fasta", 'w') as output_file:
        header = ""
        sequence = ""
        for line in input_file:
            if line.startswith(">"):
                if sequence:
                    # Trim sequence if it is longer than 450
                    if len(sequence) > 450:
                        sequence = sequence[:450]
                    # Write header and trimmed sequence to output file
                    output_file.write(header)
                    output_file.write(sequence)
                    output_file.write("\n")
                    # Reset header and sequence
                    header = line
                    sequence = ""
                else:
                    # First header
                    header = line
            else:
                # Add sequence line
                sequence += line.strip()
        # Trim and write last sequence
        if len(sequence) > 450:
            sequence = sequence[:450]
        output_file.write(header)
        output_file.write(sequence)
        output_file.write("\n")
