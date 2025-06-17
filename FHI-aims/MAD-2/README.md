# MAD 2.0: multi-target foundation data computed with `FHIaims`

This is intended as **the** master copy for running FHIaims calculations consistent with the settings used for the MAD 2.0 dataset.

## User Guide

### DFT settings

``master_control.in`` contains the standard DFT, computational, and target-specific settings. For generating data 

The targets generated are:

    - energy
    - forces
    - stress
    - Hamiltonian (real-space, printed with HDF5)
    - Density Matrix (k-space, also acts an SCF restart file)
    - Density of States
    - Polarization (i.e. dipole moment, non-metals only)
    - RI-decomposition of the electron density (from SCF restart)


### Species Defaults

The `tight` defaults are taken from FHIaims version `250610`, from directory `FHIaims/species_defaults/defaults_2020/tight`.

Then, the defaults of the Lanthanides and Actinides are modified in the following way:

TODO

to give the sepcies settings found in `tight_modified`.


### Example calculation

The `FHIaims` executable is stored at: `aims.250320.scalapack.mpi.x.cosmo.mad.2`. An
example of its use is provided in the `example/` folder.

To run this example, copy the contents of `example/` to somewhere in your `home/`
folder. Run `sbatch run-aims.sh` to compute all the targets (except polarization) for a
single water molecule in a box.


## Extra Info

### How `FHIaims` was built

`FHIaims` has been compiled from source in the directory `build/`, at release version
`250320`.

Steps to reproduce the build on Jed:

1. Download the source code from GitLab. This requires an account with access permission
   to FHIaims. Switch to the commit pinned to the `250320` release version.

```bash
cd COSMO-MAD-2/build_aims
git clone https://aims-git.rz-berlin.mpg.de/aims/FHIaims.git
# enter username and password
cd FHIaims
git checkout 59de5333d866d91f25a030e69cbcf3d78f7c35de
```

2. Create a build directory and copy the build files (specific to Jed) into it.

```bash
cp -r ../build .
cd build
```

3. Run cmake and make

```bash
./run-cmake.sh
```
Check that `FHI-aims version: 250320` is printed. Once finished successfully, run the
build:

```bash
sbatch run-make.sh
```

4. Copy the executable to an accessible place

```bash
cp tmp_build/aims.250320.scalapack.mpi.x.cosmo.mad.2 ../../../executable
```

The executable is then stored in this directory at
`COSMO-MAD-2/executable/aims.250320.scalapack.mpi.x.cosmo.mad.2`

