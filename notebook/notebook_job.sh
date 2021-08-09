#!/bin/bash

#SBATCH --get-user-env
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --time=2-00:00:00 
#SBATCH --job-name=notebook
#SBATCH --partition=jobs
#SBATCH --output=slurm.out
#SBATCH --exclusive

# Creates a python environment cluster-tutorial, if it does not exist
python3 -m venv $HOME/venv/cluster-tutorial
# activates the python environment cluster-tutorial
source $HOME/venv/cluster-tutorial/bin/activate
pip install --upgrade pip
pip install jupyter

printf "\n\nNODE_NAME: ${SLURM_JOB_NODELIST}\n\n"

jupyter notebook --no-browser --port=8889
