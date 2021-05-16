#!/bin/bash

#SBATCH --job-name=fast_sampling-slow_ram_usage
#SBATCH --partition=jobs
#SBATCH --get-user-env
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1000
#SBATCH --time=00:05:00 
#SBATCH --acctg-freq=task=1

python3 ram_usage_slow.py
