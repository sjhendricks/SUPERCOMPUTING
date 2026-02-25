#!/bin/bash
set -ueo pipefail

# save fasta file name as a variable (input)
file=${1}
# shorten file name
short=$(basename $file)
# calculate and save total number of sequences
seqs=$(grep "^>" ${file} | wc -l)
# calculate and save total number of nucleotides
nucleotides=$(grep -v "^>" ${file} |tr -d "\n" | wc -c)
# table of sequence names and lengths
table=$(seqtk comp ${file} | cut -f1,2)

echo "Total Number of Sequences in ${short}"
echo "${seqs}"
echo "Total Number of Nucleotides in ${short}:"
echo "${nucleotides}"
echo "All Sequence names and lengths:"
echo "${table}"
