#!/bin/bash

#SBATCH --job-name=default_sampling-fast_ram_usage
#SBATCH --partition=jobs
#SBATCH --get-user-env
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1000
#SBATCH --time=00:05:00 

python ram_usage_fast.py
