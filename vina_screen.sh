cat << "EOF"
            ########################################################################## 
            ##                                                                      ##
            ##          Virtual Screening Script using AutoDock Vina                ##
            ##                   Written by Gopinath Murugan                        ##
            ##       CAS in Crystallography and Biophysics, University of Madras    ##
            ##                   Email: murugangopinath12@gmail.com                 ##
            ##     https://github.com/Gopinath-Murugan/Autodock-Vina-screening      ##
            ##                                                                      ##
            ########################################################################## 
EOF

# Directory containing the ligands
ligand_dir="./ligands"

# Directory to store the results
results_dir="results"

# Number of threads for exhaustiveness
threads_per_job=12

# Ensure ligand_dir exists and contains files
if [ ! -d "$ligand_dir" ] || [ -z "$(ls -A "$ligand_dir")" ]; then
    echo "Error: Ligand directory '$ligand_dir' is empty or does not exist."
    exit 1
fi

# Ensure receptor and config files exist
if [ ! -f "receptor.pdbqt" ]; then
    echo "Error: Receptor file 'receptor.pdbqt' not found."
    exit 1
fi
if [ ! -f "config.txt" ]; then
    echo "Error: Config file 'config.txt' not found."
    exit 1
fi

# Get the number of available threads
total_threads=$(nproc)

# Ensure the total threads is a multiple of threads_per_job
if (( total_threads % threads_per_job != 0 )); then
    echo "Error: Total threads ($total_threads) is not a multiple of threads_per_job ($threads_per_job)."
    exit 1
fi

# Calculate the number of parallel jobs that can be run
jobs=$(( total_threads / threads_per_job ))

# Create the results directory if it doesn't exist
mkdir -p "$results_dir"

# Get the list of ligand files
ligands=("$ligand_dir"/*)
total_ligands=${#ligands[@]}
completed=0  # Progress tracking counter

if (( total_threads <= threads_per_job )); then
    echo "System has 12 or fewer threads. Running all ligands sequentially."

    for ligand in "${ligands[@]}"; do
        ligand_name=$(basename "$ligand")
        ligand_base="${ligand_name%.*}"

        vina --receptor receptor.pdbqt --ligand "$ligand" --out "$results_dir/${ligand_base}_out.pdbqt" \
             --config config.txt --log "$results_dir/${ligand_base}.txt"

        ((completed++))
        echo "[$completed/$total_ligands] Completed processing for $ligand_name"
    done
else
    echo "Total threads: $total_threads"
    echo "Threads per job: $threads_per_job"
    echo "Parallel jobs: $jobs"

    # Divide ligands across jobs
    ligands_per_job=$(( (total_ligands + jobs - 1) / jobs )) # Ensure rounding up

    echo "Total ligands: $total_ligands"
    echo "Ligands per job: $ligands_per_job"

    # Function to run AutoDock Vina for a subset of ligands
    run_vina() {
        local start=$1
        local end=$2
        for (( i=start; i<end; i++ )); do
            ligand="${ligands[i]}"
            ligand_name=$(basename "$ligand")
            ligand_base="${ligand_name%.*}"

            vina --receptor receptor.pdbqt --ligand "$ligand" --out "$results_dir/${ligand_base}_out.pdbqt" \
                 --config config.txt --log "$results_dir/${ligand_base}.txt"

            ((completed++))
            echo "[$completed/$total_ligands] Completed processing for $ligand_name"
        done
    }

    # Run jobs in parallel
    for (( j=0; j<jobs; j++ )); do
        start=$(( j * ligands_per_job ))
        end=$(( start + ligands_per_job ))
        if (( end > total_ligands )); then
            end=$total_ligands
        fi

        run_vina "$start" "$end" &
    done

    # Wait for all background processes to complete
    wait

fi

echo "All ligands have been screened against the receptor."

