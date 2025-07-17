#/bin/bash

module purge
module load cmake
module load intel-oneapi-compilers/2024.1.0
module load intel-oneapi-mpi/2021.12.1
module load intel-oneapi-mkl/2024.0.0
module load hdf5/1.14.3-mpi

cmake -C initial_cache.cmake ../
