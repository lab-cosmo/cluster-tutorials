#!/bin/bash

#SBATCH --get-user-env
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1MB
#SBATCH --time=7-00:00:00
#SBATCH --qos=longjobs
#SBATCH --output=qos_result.out

sleep 60
echo "SUCCESS"
