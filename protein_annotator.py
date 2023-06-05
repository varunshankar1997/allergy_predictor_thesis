with  open('results_yuchen_blastDB.csv', 'r') as f1, open('emap_out.emapper.annotations', 'r') as f2:
#with open ('emap_out.emapper.annotations') as f2: 
    # Create a dictionary to store annotations data
    annotations_dict = {}
    
    # Read annotations file and store data in dictionary
    for line in f2:
        if not line.startswith('#'): # ignore header lines
            fields = line.strip().split('\t')
            annotations_dict[fields[0]] = fields[7] # store ID and description in dictionary
    with open('results_with_descriptions.csv', 'w') as f3:
              
    
        # Iterate over each line in the results file and add description if ID match is found
        for line in f1:
            fields = line.strip().split(',')
            id = fields[0]
            if id in annotations_dict:
                description = annotations_dict[id]
            else:
                description = "N/A" # if no match found, write N/A
            new_line = line.strip() + ',' + description + '\n' # add new column with description
            f3.write(new_line) # write to new file

     
#print(annotations_dict)
