#!/bin/bash

# Display a header message about the script
cat << "EOF"
            ########################################################################## 
            ##                                                                      ##
            ##          Virtual Screening Sort Script for Autodock Vina             ##
            ##                   Written by Gopinath Murugan                        ##
            ##       CAS in Crystallography and Biophysics, University of Madras    ##
            ##                   Email: murugangopinath12@gmail.com                 ##
            ##      https://github.com/Gopinath-Murugan/Autodock-Vina-screening     ##
	    ##                                                                      ##  
            ########################################################################## 
EOF

# Directory containing the ligands
ligand_dir="./ligands"

# Directory to store the results
results_dir="./results"

# Directory for top ligands
top_ligands_dir="./Top_ligands"

# Output file names
csv_file="sorted_results.csv"
txt_file="sorted_results.txt"

# Temporary file to store intermediate data
temp_file="temp_results.txt"

# Prompt user for the number of top ligands
read -p "Enter the number of top ligands to extract: " top_count

# Create directories if they don't exist
mkdir -p "$results_dir"
mkdir -p "$top_ligands_dir"

# Extract binding energies and file names
for pdbqt_file in "$results_dir"/*.pdbqt; do
    # Extract the binding energy for MODEL 1 only
    binding_energy=$(awk '/MODEL 1/ {getline; if ($1 == "REMARK") {print $4}}' "$pdbqt_file")
    # Get the file name without path
    file_name=$(basename "$pdbqt_file")
    # Append results to temp file
    echo -e "$file_name\t$binding_energy" >> "$temp_file"
done

# Remove duplicate entries based on ligand names (file names)
sort -u "$temp_file" > "$temp_file.dedup"

# Sort by binding energy (2nd column) and get the top N results
sort -k2,2n "$temp_file.dedup" | head -n "$top_count" > "$txt_file"

# Convert to CSV format
awk -F'\t' 'BEGIN {print "Ligand,Binding energy"} {print $1","$2}' "$txt_file" > "$csv_file"

# Copy the top N ligands to the Top_ligands directory
while IFS=$'\t' read -r file_name binding_energy; do
    cp "$results_dir/$file_name" "$top_ligands_dir/"
done < "$txt_file"

# Cleanup
rm "$temp_file" "$temp_file.dedup"

echo "Results have been sorted, saved to $csv_file and $txt_file, and top $top_count ligands copied to $top_ligands_dir."

