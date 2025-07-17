#!/bin/bash
#SBATCH --job-name=FHI-aims
#SBATCH --partition=standard
#SBATCH --mem-per-cpu=0
#SBATCH --ntasks-per-node=72
#SBATCH --time=04:00:00
#SBATCH --account=cosmo

module purge
module load cmake
module load intel-oneapi-compilers/2024.1.0
module load intel-oneapi-mpi/2021.12.1
module load intel-oneapi-mkl/2024.0.0
module load hdf5/1.14.3-mpi

ulimit -s unlimited
export OMP_NUM_THREADS=1
export MKL_DYNAMIC=FALSE
export MKL_NUM_THREADS=1
export I_MPI_FABRICS=shm


srun /work/cosmo/COSMO-AIMS/FHIaims_last/build_newjed/aims.250626.hdf5.scalapack.mpi.x < control.in > aims.out
