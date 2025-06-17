#!/bin/bash
#SBATCH --job-name=aims-build
#SBATCH --nodes=1
#SBATCH --time=01:00:00
#SBATCH --partition=standard
#SBATCH --ntasks-per-node=72

module purge
module load intel intel-oneapi-mkl intel-oneapi-mpi elpa hdf5/1.12.2-mpi

make -j $(nproc)
make install
