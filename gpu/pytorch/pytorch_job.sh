#!/bin/bash

#SBATCH --get-user-env
#SBATCH --job-name=pyt-tut
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
pip install torch

# torch information
python -c "import torch; print(*torch.__config__.show().split('\n'), sep='\n')"
# run benchmark
python pytorch_bench.py > bench_results.out
