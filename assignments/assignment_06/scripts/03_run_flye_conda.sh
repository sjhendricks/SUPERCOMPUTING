#!/bin/bash
set -ueo pipefail

# load miniforge and conda. activate conda environment
module load miniforge3
source "$(conda info --base)/etc/profile.d/conda.sh"

conda activate flye-env

#  run flye on the data
flye --nano-raw ./data/SRR33939694.fastq.gz --meta --out-dir ./assemblies/assembly_conda --threads 6 --genome-size 50k

# clean up files
cd ./assemblies/assembly_conda
rm -r 00-assembly 10-consensus 20-repeat 30-contigger 40-polishing
rm assembly_graph.gfa assembly_info.txt assembly_graph.gv params.json

mv assembly.fasta conda_assembly.fasta
mv flye.log conda_flye.log

cd ../..
# deactivate environment
conda deactivate
