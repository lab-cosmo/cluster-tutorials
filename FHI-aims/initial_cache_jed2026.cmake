# Intel Compilers
set(CMAKE_Fortran_COMPILER "mpiifx" CACHE STRING "" FORCE)
set(CMAKE_Fortran_FLAGS "-O2 -fp-model precise" CACHE STRING "" FORCE)
set(Fortran_MIN_FLAGS "-O0 -fp-model precise" CACHE STRING "" FORCE)
set(CMAKE_C_COMPILER "icx" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS "-O2 -fp-model precise -std=gnu99" CACHE STRING "" FORCE)
set(CMAKE_CXX_COMPILER "icpx" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "-O2 -fp-model precise" CACHE STRING "" FORCE)
set(LIB_PATHS "$ENV{MKLROOT}/lib/intel64" CACHE STRING "" FORCE)
set(LIBS "mkl_intel_lp64 mkl_sequential mkl_core mkl_blacs_intelmpi_lp64 mkl_scalapack_lp64" CACHE STRING "" FORCE)

set(USE_MPI ON CACHE BOOL "" FORCE)
set(USE_SCALAPACK ON CACHE BOOL "" FORCE)
set(USE_LIBXC ON CACHE BOOL "" FORCE)

## use hdf5 and update flags to make it discoverable
set(USE_HDF5 ON CACHE BOOL "" FORCE)
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -I$ENV{HDF5_ROOT}/include -L$ENV{HDF5_ROOT}/lib -lhdf5_fortran -lhdf5" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I$ENV{HDF5_ROOT}/include -L$ENV{HDF5_ROOT}/lib -lhdf5" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I$ENV{HDF5_ROOT}/include -L$ENV{HDF5_ROOT}/lib -lhdf5" CACHE STRING "" FORCE)

set(USE_RLSY ON CACHE BOOL "" FORCE)
set(ELPA2_KERNEL "" CACHE STRING "Change to AVX/AVX2/AVX512 if running on Intel processors" FORCE)
set(USE_COOP ON CACHE BOOL "" FORCE)

# Use MPI wrappers for C/C++ only for ELPA
set(ELPA_C_COMPILER "mpiicx" CACHE STRING "" FORCE)
set(ELPA_CXX_COMPILER "mpiicpx" CACHE STRING "" FORCE)


## Further instructions

## 1. Make sure you are working from a compute node!

## 2. Load necessary modules
#module purge
#module load intel-oneapi-compilers
#module load intel-oneapi-mpi
#module load intel-oneapi-mkl
#module load hdf5/1.14.3-mpi

## 3. Run cmake
#cmake .. -C initial_cache.cmake

## 4. Make
#make -j 32 # (or some other number of your liking)

## 5. Enjoy good science
