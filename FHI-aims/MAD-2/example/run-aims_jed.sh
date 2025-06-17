#!/bin/bash
#SBATCH --job-name=FHI-aims
#SBATCH --partition=standard
#SBATCH --mem-per-cpu=0
#SBATCH --ntasks-per-node=72
#SBATCH --time=04:00:00
#SBATCH --account=cosmo

module purge
module load intel intel-oneapi-mkl intel-oneapi-mpi elpa hdf5/1.12.2-mpi

ulimit -s unlimited
export OMP_NUM_THREADS=1
export MKL_DYNAMIC=FALSE
export MKL_NUM_THREADS=1
export I_MPI_FABRICS=shm


srun /work/cosmo/COSMO-MAD-2/executable/aims.250610.scalapack.hdf5.mpi.cosmo.mad.2 < control.in > aims.out
