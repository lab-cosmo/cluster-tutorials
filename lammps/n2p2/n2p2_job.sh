#!/bin/bash
#SBATCH --job-name=n2p2
#SBATCH --get-user-env
#SBATCH --partition=jobs
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=2
#SBATCH --time=0:05:00

source $HOME/venv/base/bin/activate

module load intel
module load intel-mkl
module load intel-mpi
module load lammps

# export I_MPI_PMI_LIBRARY="/lib/x86_64-linux-gnu/libpmix.so.2"
# export I_MPI_PMI_LIBRARY="/usr/lib/x86_64-linux-gnu/libpmi2.so.0"
# export I_MPI_PMI2=yes
# export PMI_MMAP_SYNC_WAIT_TIME=300
# source /home/software/apps/intel/bin/compilervars.sh intel64

# please check if this is your i-pi directory
IPI=$HOME/code/i-pi/bin/i-pi
LAMMPS=lmp_mpi

cd scpimd1hvt4

sleep 1
${IPI} input.xml > i-pi.log &
sleep 5
srun --time=00:05:00 --hint=nomultithread --exclusive -n ${SLURM_NTASKS} ${LAMMPS} -i in.lmp > lammps.log &

wait
exit 0
