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

nano 01_download_data.sh

\#!/bin/bash

set -ueo pipefail

\# download genomic data

wget -P ../data https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1

## Task 3
Download Flye v2.9.6


