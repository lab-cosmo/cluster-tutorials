# Compiling `FHI-aims` on HPC

Instructions on how to compile `FHI-aims` can be foudn in their user manual at:

https://fhi-aims.org/uploads/documents/FHI-aims.221103_1.pdf (last checked: 12-02-2024)


But the important points are (page 15 in the manual)

1. Git clone the FHI-aims repository from GitLab. Navigate to the top directory,
   i.e. `.../FHIaims`

2. Load the necessary modules. These are cluster dependent, but i.e. for
   `imxgesrv1`:

    - `module load cmake`
    - `module load intel`
    - `module load intel-mkl`
    - `module load intel-mpi`

2. `mkdir build && cd build`

3. Create a cmake file called `initial_cache.cmake`. The example one shipped
   with aims can be used (`FHIaims/initial_cache.example.cmake`), or use one of
   the examples in this repository for specific HPC clusters:

    - jed: [`initial_cache_jed.cmake`](initial_cache_jed.cmake)
    - imxgesrv1: [`initial_cache_imxgesrv1.cmake`](initial_cache_imxgesrv1.cmake)

4. `cmake -C initial_cache.cmake ..` (capital C)

5. `make -j [number]` (where `number` is the number of cores to compile with)
