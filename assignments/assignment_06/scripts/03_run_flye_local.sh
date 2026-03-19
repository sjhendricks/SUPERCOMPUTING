#!/bin/bash
set -ueo pipefail

#  run flye on the data
flye --nano-raw ./data/SRR33939694.fastq.gz --meta --out-dir ./assemblies/assembly_local --threads 6 --genome-size 100k

# clean up files
cd ./assemblies/assembly_local
rm -r 00-assembly 10-consensus 20-repeat 30-contigger 40-polishing
rm assembly_graph.gfa assembly_info.txt assembly_graph.gv params.json

mv assembly.fasta local_assembly.fasta
mv flye.log local_flye.log

cd ../..
