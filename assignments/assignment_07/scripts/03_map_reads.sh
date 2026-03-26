#!/bin/bash
set -ueo pipefail

BASE_DIR="/sciclone/scr10/sjhendricks/assignment_07"
DATA_DIR="${BASE_DIR}/data"
OUT_DIR="${BASE_DIR}/output"
REF_DIR="${DATA_DIR}/dog_reference"
REF="${REF_DIR}/ncbi_dataset/data/GCF_011100685.1/GCF_011100685.1_UU_Cfam_GSD_1.0_genomic.fna"

# set up environment
module load miniforge3
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate bbmap-env

# run bbmap
for FWD in ${DATA_DIR}/clean/*_1_trimmed.fastq
do
bbmap.sh ref=${REF} in1=$FWD in2=${FWD/_1/_2} out=${OUT_DIR}/mapped_to_dog.sam minid=0.95 -Xmx16g
done;

conda deactivate

# use samtools to extract read matches to dog reference genome.
samtools view -F 4 ${OUT_DIR}/mapped_to_dog_reference.sam > ${OUT_DIR}/mapped_reads.sam
