#!/bin/bash
set -ueo pipefail
#usage: ./prep_fastq.sh

# download fastq data
wget https://gzahn.github.io/data/fastq_examples.tar
tar -xvf fastq_examples.tar -C ./data/raw

# remove  tar file
rm fastq_examples.tar


