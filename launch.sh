#!/bin/bash

#SBATCH --job-name SBVS
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 2
#SBATCH --output /dev/null
#SBATCH --error slurm.err
#SBATCH --array 0-1898
#SBATCH --mem-per-cpu=1gb
#SBATCH --time 4:00:00
#SBATCH --account kireevlab

source ~/Tools/software/miniconda3/etc/profile.d/conda.sh
conda activate obabel
arr=(`ls INPUT/*`)
bash main.sh  ${arr[$SLURM_ARRAY_TASK_ID]}
