# MAD 2.0: multi-target foundation data computed with `FHIaims`

This is intended as **the** master copy for running FHIaims calculations consistent with the settings used for the MAD 2.0 dataset.

## User Guide

### DFT settings

``master_control.in`` contains the standard DFT, computational, and target-specific settings. For generating data 

The targets generated are as default:

    - energy
    - forces
    - stress
    - Density Matrix (k-space, also acts an SCF restart file)

if uncommented:

    - Hamiltonian (real-space, printed with HDF5)
    - Density of States

### Species Defaults

The `tight` defaults are taken from FHIaims version `250610`, from directory `FHIaims/species_defaults/defaults_2020/tight`.

Then, the defaults of the Lanthanides and Actinides are modified in the following way:

```bash
for file in *_default; do
    if [ -f "$file" ]; then
        # Only edit files that contain a line starting with "# confined"
        if grep -q "confined" "$file"; then
            sed -i 's/confined/# confined/' "$file"
            echo "Commented 'confined' in $file"
        fi
    fi
done
```

to give the sepcies settings found in `tight_modified`.


### Example calculation

The `FHIaims` executable is stored at: `aims.250610.scalapack.hdf5.mpi.cosmo.mad.2`. An
example of its use is provided in the `example/` folder.

To run this example, copy the contents of `example/` to somewhere in your `home/`
folder. Run `sbatch run-aims.sh` to compute all the targets.


## Extra Info

### How `FHIaims` was built

`FHIaims` has been compiled from source in the directory `build/`.

Steps to reproduce the build on Jed:

1. Download the source code from GitLab. This requires an account with access permission
   to FHIaims. Switch to the commit pinned to the `250610` version, which specifically enables support for ScaLAPACK and HDF5.

```bash
git clone https://aims-git.rz-berlin.mpg.de/aims/FHIaims.git
# enter username and password
cd FHIaims
git checkout 5f2c1992e53bf04e6e851868574be74f8785d344
```

2. Create a build directory and copy the build files (specific to Jed) into it.

```bash
mkdir build
cp  ../ .
```

3. Run cmake and make

```bash
./run-cmake.sh
```
Check that `FHI-aims version: 250610` is printed. Once finished successfully, run the
build:

```bash
sbatch run-make.sh
```
The executable is then stored in this directory at
`COSMO-MAD-2/executable/aims.250610.scalapack.hdf5.mpi.cosmo.mad.2`

