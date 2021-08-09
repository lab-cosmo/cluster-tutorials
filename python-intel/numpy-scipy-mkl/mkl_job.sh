#!/bin/bash

#SBATCH --get-user-env
#SBATCH --job-name=py-mkl
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --time=0:10:00
#SBATCH --partition=jobs


#########################
# Standard python 3.8.5 #
#########################

module purge
# First we run one time python witout any module. You will see it uses OpenBLAS when the module is not loaded
which python3
python3 --version
python3 -c "import numpy as np; print('numpy version:', np.__version__); np.show_config()"
# we create a virtual environmet for a speed comparison
python3 -m venv --system-site-packages $HOME/venv/openblas-base
source $HOME/venv/openblas-base/bin/activate
python -m pip install --upgrade pip
printf "\n"
# small benchmark for matrix multiplication for a 10000 x 1000 matrix
python -m timeit -n 20 "import numpy as np; np.random.seed(0); m=np.random.rand(10000, 1000); m@m.T"
printf "\n\n\n"


##############################################
# python 3.7.7 with intel optimized packages #
##############################################

module load intel
module load intel-mkl 
module load python

# Now you see that it uses the intel MKL library
which python3
python3 --version
python3 -c "import numpy as np; print('numpy version:', np.__version__); np.show_config()"
# You can create a virtual environment with MKL compiled numpy version
# by adding an optional argument to use the system installed packages
python3 -m venv --system-site-packages /home/goscinsk/venv/mkl-base
source $HOME/venv/mkl-base/bin/activate
python -m pip install --upgrade pip
printf "\n"
# small benchmark for matrix multiplication for a 10000 x 1000 matrix
python -m timeit -n 20 "import numpy as np; np.random.seed(0); m=np.random.rand(10000, 1000); m@m.T"
printf "\n\n\n"

# You can use keep this environment as base and create new mkl environments for playing around
#cp -R $HOME/venv/mkl-base $HOME/venv/mkl-playground
# replace the usage of mkl-base with the new folder name to prevent usage of the copied directory
#find $HOME/venv/jacobian -type f -exec sed -i 's/mkl-base/mkl-playground/g' {} \

# if you want to use again the standard python version
deactivate
module purge

# If you use python with intel optimized packages always load the modules to prevent bugs
# If you use python without intel optimized packages always purge the modules to prevent bugs 
