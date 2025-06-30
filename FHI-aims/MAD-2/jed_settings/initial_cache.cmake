## This was taken from FHIaims/cmake/toolchains/intel.cmake version 250320. Any modifcations made are indicated.

set(TARGET_NAME aims.250626.scalapack.hdf5.mpi.cosmo.mad.2 CACHE STRING "")
set(CMAKE_INSTALL_PREFIX "./" CACHE STRING "")

###############
# Basic Flags #
###############
set(CMAKE_Fortran_COMPILER mpiifort CACHE STRING "")
set(CMAKE_Fortran_FLAGS "-O3 -ip -fp-model precise" CACHE STRING "")
set(Fortran_MIN_FLAGS "-O0 -fp-model precise" CACHE STRING "")
set(INC_PATHS "$ENV{HDF5_ROOT}/include" CACHE STRING "")  # added
set(LIB_PATHS "$ENV{MKLROOT}/lib/intel64 $ENV{HDF5_HOME}/lib" CACHE STRING "")  # modified to include HDF5 lib
set(HDF5_Fortran_INCLUDE_DIR "$ENV{HDF5_ROOT}/include" CACHE STRING "")  # added
set(LIBS "mkl_scalapack_lp64 mkl_blacs_intelmpi_lp64 mkl_intel_lp64 mkl_sequential mkl_core hdf5_fortran hdf5" CACHE STRING "")  # modified to include `hdf5_fortran` and `hdf5`
set(USE_COOP ON CACHE STRING "")

###############
# C,C++ Flags #
###############
set(CMAKE_C_COMPILER icc CACHE STRING "")
set(CMAKE_C_FLAGS "-O3 -ip -fp-model precise -std=gnu99" CACHE STRING "")
set(CMAKE_CXX_COMPILER icpc CACHE STRING "")
set(CMAKE_CXX_FLAGS "-O3 -ip -fp-model precise" CACHE STRING "")

set(ELPA2_KERNEL "" CACHE STRING "Change to AVX/AVX2/AVX512 if running on Intel processors")

########################
# Modifications by Joe #
########################
set(USE_CXX_FILES ON CACHE BOOL "")
set(USE_MPI ON CACHE BOOL "" FORCE)
set(USE_SCALAPACK ON CACHE BOOL "" FORCE)
set(USE_LIBXC ON CACHE BOOL "" FORCE)
set(USE_HDF5 ON CACHE BOOL "" FORCE)
set(USE_RLSY ON CACHE BOOL "" FORCE)
