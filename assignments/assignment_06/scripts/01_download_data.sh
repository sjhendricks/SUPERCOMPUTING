#!/bin/bash
set -ueo pipefail

# download genomic data
wget -P ../data https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1

# rename data to be usable with flye
cd ../data
mv 'SRR33939694.fastq.gz?download=1' SRR33939694.fastq.gz

cd ..
