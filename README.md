# Virtual Screening Script using AutoDock Vina

This script automates virtual screening using the AutoDock Vina docking tool, leveraging multithreading for efficient computations.

## Prerequisites

To use this script, ensure the following:

1. **System Requirements**:

   - A system with sufficient CPU cores to handle parallel jobs.
   - Examples of supported systems:
     - High-performance workstations
     - Servers with multiple CPU cores
   - Ensure multithreading is supported and optimized.

2. **AutoDock Vina Installation**:

   - Install AutoDock Vina from the official website or repository.
   - Follow the official installation guide for setup.

3. **Protein File**:

   - The receptor protein file should be named `receptor.pdbqt`.
   - Place the file in the same directory as the script.

4. **Ligands Folder**:

   - All ligand files should be placed in the `ligands` folder.
   - Ligands must be in `.pdbqt` format.

5. **Configuration File**:

   - The script uses a configuration file named `config.txt`.
   - Ensure the file includes the following parameters:
     ```plaintext
     center_x = -24.247
     center_y = 11.918
     center_z = 11.502
     size_x = 30
     size_y = 30
     size_z = 30
     exhaustiveness = 12
     ```
   - Note: The search box size should not exceed 30 units for `size_x`, `size_y`, and `size_z`.

6. **Usage**:

   1. Clone or download the script to your local system.
   2. Place the `receptor.pdbqt` file in the script's directory.
   3. Ensure all ligand files are in the `ligands` folder and are in `.pdbqt` format.
   4. Verify the `config.txt` file is properly configured as shown above.
   5. Run the screening script:
      ```bash
      bash vina_screen.sh
      ```
   6. The results will be saved in the `results` directory.

7. **Sorting and Selecting Top Ligands**:

   To sort the results and extract top ligands, use the sorting script:

   ```bash
   bash vina_sort.sh
   ```

   - The script prompts the user to specify the number of top ligands to extract.
   - Results are saved in `sorted_results.csv` and `sorted_results.txt`.
   - Top ligands are copied to the `Top_ligands` directory.

## Output

- For each ligand, a result file with docking details will be created in the `results` folder.
- The script prints progress updates for each ligand processed.

## Additional Notes

- Ensure proper permissions for executing the script (`chmod +x script_name.sh`).
- CPU limitations may arise if too many ligands are processed at once. Consider adjusting the number of threads if needed.
- For optimal performance, ensure all dependencies are correctly installed and the system is updated.

## Citation

If you are using this script for your studies, kindly acknowledge the use of AutoDock Vina as per its citation guidelines and mention my GitHub repository:

Trott, Oleg, and Arthur J. Olson. "AutoDock Vina: improving the speed and accuracy of docking with a new scoring function, efficient optimization, and multithreading." Journal of computational chemistry 31.2 (2010): 455-461. [https://doi.org/10.1002/jcc.21334](https://doi.org/10.1002/jcc.21334)

For the latest version of this script and updates, visit my GitHub repository:
[https://github.com/Gopinath-Murugan/AutoDock-Vina-screening](https://github.com/Gopinath-Murugan/AutoDock-Vina-screening)

Mentioning this repository in your publications or research would be greatly appreciated.

Happy docking!


