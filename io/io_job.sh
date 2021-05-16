#!/bin/bash

#SBATCH --get-user-env
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1000
#SBATCH --time=00:05:00 
#SBATCH --output=io_result.out

echo "Tests on $HOME"
echo
dd if=/dev/zero of=$HOME/tmp bs=512K count=2048
echo
dd if=/dev/zero of=$HOME/tmp bs=64M count=16
echo
dd if=/dev/zero of=$HOME/tmp bs=1G count=1
rm $HOME/tmp

printf "\n\n\n"

echo "Tests on $SCRATCH"
echo
dd if=/dev/zero of=$SCRATCH/tmp bs=512K count=2048
echo
dd if=/dev/zero of=$SCRATCH/tmp bs=64M count=16
echo
dd if=/dev/zero of=$SCRATCH/tmp bs=1G count=1
rm $SCRATCH/tmp
