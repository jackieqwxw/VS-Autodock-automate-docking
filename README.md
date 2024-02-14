## VS-Autodock-automate-docking
This tool will use Autodock to perform automate molecular docking in batch 

# Installation
Install openbabel on Linux using conda:
```
conda create -n obabel python=3.8
```
```
conda activate obabel
```
```
conda install -c conda-forge openbabel
```
# Prerequisites
1. Download and install Autodock Tools from the official site. A binary smina file is attached. Smina is a fork of Autodock Vina with enchanced scoring function.

2. Download  MGLTools (platform Linux) and set environment variable. The path should be `/your_path/mgltools_x86_64Linux2_1.5.6/bin`. We will use `python2.5` under this path for preparing ligands for Autodock docking.

3. Prepare you protein thorougly before docking. You can use Protein Preparation tools in Maestro or any other software you like. Google 'protein preparation before docking'.

4. Generate pdbqt file of receptor and grid file `config.txt` shown as attached.

5. Prepare you database in a format "smiles id". An example 'ligands.smi' is attached.


# Run structural-based virtual screening (SBVS) of the ligand database on the protein of your interest in parallel
Here, we used `MolPort` database as an example:

1. Make sure the Molport database was downloaded in the working directory. 

2. Split the database into multiple smaller files containing couples of molecules such as 350 using the split command:
```
split -l 350 -d -e --additional-suffix=.smi name_of_MolPortfile name_of_splitfile
```

3. Note the number of split flies that were made by entering this on the command line (e.g., files from 0-22,784): 
```
ls | wc -l 
```

4. Set to run SBVS in parallel:

4.1 Open the `launch.sh` script and edit the file based on the number of split files that were generated: `--array 0-22784`. Modify this array number accordingly.
   
4.2 Use the option `--partition` to specify the partition. If not specified the partition, the jobs would be automatically to the General partition. 

4.3 Specifying the option `--time` dependent on the different partitions. 

4.4 Set up the CPU cores by the option `--cpus-per-task`. 2 or 4 CPUs are recommended here since we can decrease the waiting time of queue if extensive jobs were about to be submitted.

4.5 Update the location of `conda.sh`. Mine is at `~/Tools/software/miniconda3/etc/profile.d/conda.sh`. Or, run `conda activate obabel` to activate obabel enviroment.

4.6 For current bash script setting, we can explain that each job contains 350 compounds. It will use 2 CPUs to run docking for each job. The time limit for running one splilt job file is 4 hours. It can run 2,000 jobs in parallel at a time.
 
5. Submit and run the job script:
```
sbatch launch.sh
```

When the calculation on VS was done, you will get multiple output files with the suffix ‘.out’.

6. Selecting the top-ranking compounds based on Autodock scores can be achieved by executing the following script after performing virtual screening:
```
bash ./data_process_after_Autodock.sh
```
This script will select the top 5000 compounds (for example) based on Autodock scores and generate an output file named `AD_select.sdf`. This file can then be used for further refined docking process.
