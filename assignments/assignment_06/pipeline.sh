#!/bin/bash
set -ueo pipefail

# download data
./scripts/01_download_data.sh

# build flye locally
./scripts/02_flye_2.9.6_manual_build.sh

# install flye using conda
./scripts/02_flye_2.9.6_conda_install.sh

# run flye using conda
./scripts/03_run_flye_conda.sh

# run flye using module
./scripts/03_run_flye_module.sh

# run flye using local
./scripts/03_run_flye_local.sh

# compare log files
cat ./assemblies/assembly_conda/conda_flye.log | tail -n 10
cat ./assemblies/assembly_module/module_flye.log | tail -n 10
cat ./assemblies/assembly_local/local_flye.log | tail -n 10
