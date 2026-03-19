# Assignment 06
Sarah Hendricks

03/18/26

## Task 1
Create designated directories for assignment_06

cd SUPERCOMPUTING/assignments/assignment_06 #(already created)

mkdir -p ./assemblies/assembly_conda ./assemblies/assembly_local ./assemblies/assembly_module

mkdir -p ./data ./scripts

## Task 2
Download data and create script

nano ./scripts/01_download_data.sh

---------------

\#!/bin/bash
set -ueo pipefail

\# download genomic data

wget -P ../data https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1

\# rename data to be usable with flye

cd ../data

mv 'SRR33939694.fastq.gz?download=1' SRR33939694.fastq.gz

cd ..
---------------

chmod +x 01_download_data.sh

## Task 3
Download Flye v2.9.6 using local build

Download instructions can be found at: https://github.com/mikolmogorov/Flye/blob/flye/docs/INSTALL.md#local-building-without-installation

nano ./scripts/02_flye_2.9.6_manual_build.sh

---------------
\#!/bin/bash

set -ueo pipefail

cd ~/programs

\# manually install flye v2.9.6

git clone https://github.com/fenderglass/Flye

cd Flye

make
---------------

chmod +x ./scripts/02_flye_2.9.6_manual_build.sh

\# Add Flye to path

nano ~/.bashrc

export PATH=$PATH:/sciclone/home/sjhendricks/programs/Flye/bin

cd ~/SUPERCOMPUTING/assignments/assignment_06

## Task 4
Get flye v2.9.6 with conda

nano ./scripts/02_flye_2.9.6_conda_install.sh

---------------

\#!/bin/bash

set -ueo pipefail

\# setup conda

module load miniforge3

source "$(conda info --base)/etc/profile.d/conda.sh"

\# create environment for flye

mamba create -y -n flye-env flye=2.9.6 -c bioconda

conda activate flye-env

\# check flye version

flye -v

\# document environment using yml

conda env export --no-builds > flye-env.yml

\# deactivate environment

conda deactivate

---------------

chmod +x ./scripts/02_flye_2.9.6_conda_install.sh

## Task 5
Using flye

I used the flye documentation and chatgpt to figure out the best course of action for using flye.

The command I ended up with is:

flye --nano-raw ./data/SRR33939694.fastq.gz --meta  --out-dir OUT_DIR --threads 6 --genome-size 50k

The data we are using is raw ONT data, so we will use --nano-raw

--meta is used since there may be multiple phages in the data

--out-dir will depend on task 6/desired output folder

--threads 6 determines that we will use 6 threads/cores for the assembly

--genome-size 50k was suggested to be a reasonable estimate for a coliphage genome after some research

More information on the data is found here: https://www.ncbi.nlm.nih.gov/sra/SRX29141853[accn]

## Task 6

here, input each script and what you changed for each described.
