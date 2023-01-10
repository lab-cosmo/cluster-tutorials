Intel MPI basics
----------------

You can run an MPI exectable in an Slurm session:
```
mpirun <EXECUTABLE>
```
You can get into a Slurm session with
```
salloc <OPTIONS> # runs the terminal in login node
```
or
```
srun <OPTIONS> --pty bash 
```

You can directly start the MPI executable in an interactive Slurm session with
```
salloc <OPTIONS> mpirun <EXECUTABLE>
```
or
```
srun <OPTIONS> mpirun <EXECUTABLE>
```

If you don't want an interactive session, you can use `srun` in the submitted sbatch job script
```
srun <EXECUTABLE>
```
See the `mpi_job` job file as example to run intel MPI benchmark

## FAQs

**Q1. My job is in a stale state with an Slurm error
`PMK_KVS_Barrier duplicate request from task 0`. Why is this?**

This may come from the using only `mpirun <EXECUTABLE>` in your Slurm submission script.
Try replacing with `srun <OPTIONS> mpirun <EXECUTABLE>`.
