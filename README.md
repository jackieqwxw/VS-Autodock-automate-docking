## VS-Autodock-docking
This tool will use Autodock to perform automate molecular docking in batch on Linux system.

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
1. Smina is a fork of Autodock Vina with enchanced scoring function. We use smina.static for docking calculations. Download and upload the binary smina.static file to your working directory. Change the mode of the file `smina.static` by using the command:
```
chmod +x smina.static
```

2. Download  [MGLTools](https://ccsb.scripps.edu/mgltools/downloads/) (platform Linux) and set environment variable under the hidden file `~/.bashrc`. The path should be `/your_path/mgltools_x86_64Linux2_1.5.6/bin`. Change the path name accordingly. We will use `python2.5` under this path for preparing ligands for Autodock docking.
```
vi ~/.bashrc
```
```
export PATH="/you_path/mgltools_x86_64Linux2_1.5.6/bin:/your_path/mgltools_x86_64Linux2_1.5.6/bin:$PATH"
```
```
source ~/.bashrc
```

3. Prepare you protein thorougly before docking. You can use Protein Preparation tools in Maestro or any other software you like. Google 'protein preparation before docking'.

4. Download [MGLTools](https://ccsb.scripps.edu/mgltools/downloads/) (platform Windows) to install. We will use `AutoDockTools-1.5.x` to generate pdbqt file of receptor and grid file `config.txt` shown as attached.

5. Prepare you database in a format "smiles id". An example 'ligands.smi' is attached.


# Run structural-based virtual screening (SBVS) of the ligand database on the protein of your interest in parallel
Here, we used a portion of MolPort database to generate the SMILES file `ligands.smi` as an example:

1. Make sure the file `ligands.smi` was uploaded in your working directory. 

2. Split the database into multiple smaller files containing couples of molecules such as 5 using the split command. Change `name_of_splitfile` to any:
```
split -l 5 -d -e --additional-suffix=.smi ligands.smi name_of_splitfile
```

3. Count the number of split flies that were made by entering this on the command line (e.g., files from 0-1898): 
```
ls | wc -l 
```

4. Set to run SBVS in parallel:

4.1 Open the `launch.sh` script and edit the file based on the number of split files that were generated: `--array 0-1898`. Modify this array number accordingly.
   
4.2 Use the option `--partition` to specify the partition. If not specified the partition, the jobs would be automatically to the General partition. 

4.3 Specifying the option `--time` dependent on the different partitions. 

4.4 Set up the CPU cores by the option `--cpus-per-task`. 2 or 4 CPUs are recommended here since we can decrease the waiting time of queue if extensive jobs were about to be submitted.

4.5 Update the location of `conda.sh`. Mine is at `~/Tools/software/miniconda3/etc/profile.d/conda.sh`. Or, run `conda activate obabel` to activate obabel enviroment.

4.6 For current bash script setting, we can explain that each job contains 5 compounds. It will use 2 CPUs to run docking for each job. The time limit for running one splilt job file is 4 hours. It can run 1,899 jobs in parallel at a time.
 
5. Submit and run the job script:
```
sbatch launch.sh
```
When the calculation on VS was done, you will get multiple output files with the suffix ‘.out’.

6. Selecting the top-ranking compounds based on Autodock scores can be achieved by executing the following script after performing virtual screening:
```
bash ./data_process_after_Autodock.sh
```
This script will select the top 5000 compounds (change this number accordingly) based on Autodock scores and generate an output file named `AD_select.sdf`. This file can then be used for further refined docking process.
