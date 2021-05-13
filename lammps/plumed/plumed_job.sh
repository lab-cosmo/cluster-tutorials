#!/bin/bash

#SBATCH --job-name=plumed
#SBATCH --get-user-env
#SBATCH --partition=jobs
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=1
#SBATCH --time=0:05:00

source $HOME/venv/base/bin/activate

module load intel
module load intel-mkl
module load intel-mpi
module load lammps

LAMMPS=lmp_mpi

cd example_natasha

fix pl all plumed all plumed plumedfile plumed.dat outfile p.log

srun --time=00:05:00 --hint=nomultithread --exclusive -n 2 ${LAMMPS} -i in.lmp > out.lmp &

wait
exit 0
