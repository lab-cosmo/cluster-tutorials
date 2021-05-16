#!/bin/bash

#SBATCH --get-user-env
#SBATCH --job-name=schnet
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0:05:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1

module purge
module load hpc-sdk

# Here you could use for virtual environment
# If not changed it automatically creates one, it should not be overwrited
python3 -m venv $HOME/venv/cluster-tutorial
source $HOME/venv/cluster-tutorial/bin/activate
python -m pip install --upgrade pip
pip install schnetpack

# used in the python script to locate the qm9.db file
# we just use the qm9.db in my home folder
export QM9_DIRECTORY=/exports/commonscratch/goscinsk/datasets/qm9
# used in the python script
export MODEL_DIRECTORY=$SCRATCH/schnet/models/schnet_tut/
mkdir -p ${MODEL_DIRECTORY}

# run benchmark with python version from virtual environment
python schnet_ram.py
