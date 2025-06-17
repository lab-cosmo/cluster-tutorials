#/bin/bash

module purge
module load cmake intel intel-oneapi-mkl intel-oneapi-mpi elpa hdf5/1.12.2-mpi

cmake -C initial_cache.cmake ../
