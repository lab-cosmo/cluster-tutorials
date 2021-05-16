#!/bin/bash

#SBATCH --get-user-env
#SBATCH --job-name=py-sklearn
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --time=0:10:00
#SBATCH --partition=jobs

# You can use the intel optimized python module or with standard python
# Here we use standard python version

# Install intels optimized scikit version
# https://github.com/intel/scikit-learn-intelex
python3 -m venv $HOME/venv/intel-sklearn
source $HOME/venv/intel-sklearn/bin/activate
pip install --upgrade pip
pip install scikit-learn
pip install scikit-learn-intelex

printf "\n\n\n"

which python3
python3 --version
python3 sklearn_bench.py
