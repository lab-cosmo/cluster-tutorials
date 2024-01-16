Please install on the front node because tmp dir on the gpu node is too small.
```bash
module purge
module load hpc-sdk gcc cmake

pip install torch --index-url https://download.pytorch.org/whl/cu118
pip install metatensor-torch
```
