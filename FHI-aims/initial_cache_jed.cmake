## This file was taken from FHIaims/cmake/toolchains/intel.cmake
## version 240926. Any modifcations made are indicated.

set(TARGET_NAME aims.x CACHE STRING "")  # comment this out to instead have a version-stamped exectuable
set(CMAKE_INSTALL_PREFIX "$ENV{AIMS_HOME}" CACHE STRING "")

###############
# Basic Flags #
###############
set(CMAKE_Fortran_COMPILER mpiifort CACHE STRING "")
set(CMAKE_Fortran_FLAGS "-O3 -ip -fp-model precise" CACHE STRING "")
set(Fortran_MIN_FLAGS "-O0 -fp-model precise" CACHE STRING "")
set(LIB_PATHS "$ENV{MKLROOT}/lib/intel64" CACHE STRING "")
set(LIBS "mkl_scalapack_lp64 mkl_blacs_intelmpi_lp64 mkl_intel_lp64 mkl_sequential mkl_core" CACHE STRING "")
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
set(USE_MPI ON CACHE BOOL "" FORCE)
set(USE_SCALAPACK ON CACHE BOOL "" FORCE)
set(USE_LIBXC ON CACHE BOOL "" FORCE)
set(USE_HDF5 OFF CACHE BOOL "" FORCE)
set(USE_RLSY ON CACHE BOOL "" FORCE)
