#!/bin/bash
set -ueo pipefail

# download genomic data
wget -P ./data https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1

# rename data to be usable with flye
mv ./data/'SRR33939694.fastq.gz?download=1' ./data/SRR33939694.fastq.gz


