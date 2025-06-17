# MAD 2.0: multi-target foundation data computed with `FHIaims`

**Wiki authors: Joe Abbott, Cesare Malosso**

> [!TIP]
> **What is this guide for?** The idea is to provide a common set of FHIaims settings for all COSMO-nauts who want to run DFT on their dataset to use. By doing so, it will allow us to coherently perform fine-tuning, transfer learning, and application-focussed test cases of the (not yet existing) PET-MAD-2 mutli-target foundation model.

## User Guide

### DFT settings

``master_control.in`` contains the standard DFT, computational, and target-specific settings for generating data. Calculations are performed in a two-step process. First, SCF is converged and the following targets generated.

Those generated as default:

    - energy
    - forces
    - stress
    - Density Matrix (k-space, also acts an SCF restart file)
    - Hamiltonian (real-space, printed with HDF5)
    - Density of States

Then an SCF restart is optionally performed to generate the extra targets:

    - polarization (in the case of non-metals only)
    - electron density basis decomposition

> [!WARNING]
> We are currently in the process of testing the restart functionality for generating the polarization and density decompositions. As these are submitted as subsequent and separate calculations, generation of the above targets can be performed as usual first, with extension to these optional targets if necessary. Check back soon for details.

The outputting of these targets and all other required DFT settings are provided in the example [`control.in`](example/control.in) with header:

```
# ==============================================================================
# One control.in to rule them all, and in the darkness bind them.
# 
# Created by COSMOnauts, for COSMOnauts.
#
# ==============================================================================
...
```


### Species Defaults

The `tight` defaults are taken from FHIaims version `250610`, from directory `FHIaims/species_defaults/defaults_2020/tight`.

Then, the defaults of the Lanthanides and Actinides are modified in the following way, removing an extra confinement basis function:

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

To give the species settings found in `species_defaults/tight_modified`.


### Example calculation - Jed (SCITAS)

An example demonstrating its usage is available in the `example/` directory. 
The provided submission script is configured for the Jed system but can be 
adapted to other HPC environments as needed.

To run this example, copy the contents of `example/` to somewhere in your `home/`
folder. Run `sbatch run-aims_jed.sh` to compute all the targets.


### Scripts

Python script for reading an `xyz` trajectory file and setting up an FHIaims 
calculation for each frame is available at `scripts/prepare_aims_input.py`.

## Extra Info

### How `FHIaims` was built

> [!IMPORTANT]
> To be updated once [this merge request](https://aims-git.rz-berlin.mpg.de/aims/FHIaims/-/merge_requests/1843) on the FHIaims GitLab has been merged to the main branch.

`FHIaims` has been compiled from source in the directory `build/`.

Steps to reproduce the build on Jed:

1. Download the source code from GitLab. This requires an account with access permission
   to FHIaims. Switch to the commit pinned to the `250610` version, which specifically 
   enables support for ScaLAPACK and HDF5.

```bash
git clone https://aims-git.rz-berlin.mpg.de/aims/FHIaims.git
# enter username and password
cd FHIaims
git checkout 5f2c1992e53bf04e6e851868574be74f8785d344
```

2. Create a build directory and copy the build files (specific to Jed) into it.

```bash
mkdir build
cd build
cp  ../../jed_settings/* .
```

3. Run cmake and make

```bash
./run-cmake.sh
```
Check that `FHIaims version: 250610` is printed. Once finished successfully, run the
build:

```bash
sbatch run-make.sh
```

The executable is then under the file name `aims.250610.scalapack.hdf5.mpi.cosmo.mad.2`. For convenience, we also store this on SCITAS at path: `/work/cosmo/COSMO-MAD-2/executable/aims.250610.scalapack.hdf5.mpi.cosmo.mad.2`.

