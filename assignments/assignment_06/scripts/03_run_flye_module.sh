#!/bin/bash
set -ueo pipefail

# load module environment
module load Flye

#  run flye on the data
flye --nano-raw ./data/SRR33939694.fastq.gz --meta --out-dir ./assemblies/assembly_module --threads 6 --genome-size 100k

# clean up files
cd ./assemblies/assembly_module
rm -r 00-assembly 10-consensus 20-repeat 30-contigger 40-polishing
rm assembly_graph.gfa assembly_info.txt assembly_graph.gv params.json

mv assembly.fasta module_assembly.fasta
mv flye.log module_flye.log

cd ../..
