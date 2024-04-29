## Installing `sphericart` on `izar`

You have to do the installation on an interactive node *with* GPU. Currently, `sphericart` compiles in parallel and uses a lot of RAM, so request a node with some amount of RAM larger than 4GB, or edit `sphericart-torch/setup.py` and remove the `--parallel` flag from the `cmake` invocation.

You can request a suitable node with:

```bash
Sinteract -g gpu:1 -t 01:00:00 -m 32G
```

Once you have the node, run something along these lines:


```bash

# -- prerequisites --

module purge
module load git
module load gcc/11.3.0
module load python/3.10.4
module load cuda/12.1.1
module load cudnn/8.9.7.29-12


# make & activate venv for this -- skip if you already have one
cd ~
mkdir envs
cd envs/

python -m venv torch-1
source torch-1/bin/activate

# this will install the current version of pytorch, with CUDA
pip install torch

# -- now sphericart --

git clone https://github.com/lab-cosmo/sphericart
cd sphericart
# maybe edit setup.py if RAM is an issue
pip install .[torch]

```

That's it, enjoy.
