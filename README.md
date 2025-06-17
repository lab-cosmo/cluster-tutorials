## Overview

Contains mini tutorials to cover a variety of use cases of running jobs on clusters.
Please run the jobs in their respective folder. The script use `--get-user-env` to automatically cd into the folder.

> [!TIP]
> For instructions on using pre-built FHIaims executables to generate data consistent with MAD-2 settings, see [the README](FHI-aims/MAD-2/README.md) in the FHIaims subdirectory.


## FAQs

**Q1. When installing a new package on the cluster, I encounter an error where I run out of disk space. What should I do?**

You should install packages that require a large tmp directory on the login node, the tmp directory on the other nodes is limited to ~2GB.
