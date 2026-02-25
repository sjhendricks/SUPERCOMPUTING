#!/bin/bash
set -ueo pipefail

# save fasta file name as a variable (input)
file=$1
# calculate and save total number of sequences
seqs=(grep "^>" file | wc -l)
# calculate and save total number of nucleotides
nucleotides=(grep -v "^>" file | wc -c)
# table of sequence names and lengths

