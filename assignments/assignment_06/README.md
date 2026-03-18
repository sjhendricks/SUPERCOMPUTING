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

\# manually install flye v2.9.7

git clone https://github.com/fenderglass/Flye

cd Flye

make
---------------

chmod +x 02_flye_2.9.6_manula_build.sh

\# Add Flye to path

nano ~/.bashrc

export PATH=$PATH:/sciclone/home/sjhendricks/programs/Flye/bin

## Task 4
