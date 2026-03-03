#!/bin/bash
set -ueo pipefail

# take files as inputs

# run seqkit stats on them all
seqkit stats  ${SHARED_DIR}/lesson_05/data/*.fastq >./output/stats.tsv
# export results
