#!/bin/bash
set -ueo pipefail

# setup conda
module load miniforge3
source "$(conda info --base)/etc/profile.d/conda.sh"

# create environment for flye
mamba create -y -n flye-env -c bioconda flye=2.9.6

activate flye-env

# check flye version
flye -v

# document environment using yml
conda env export --no-builds > flye-env.yml

# deactivate environment
deactiveate flye-env
