#!/bin/bash
set -ueo pipefail

BASE_DIR="/sciclone/home/sjhendricks/SUPERCOMPUTING/assignments/assignment_07"
DATA_DIR="${BASE_DIR}/data"
OUT_DIR="${BASE_DIR}/output"

# set up environment
module load miniforge3
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate bbmap-env

# run bbmap
for accession in $(cat ./data/SraRunTable.csv | cut -d',' -f1 | tail -n +2);
do
FWD_IN="./data/clean/${accession}_1_trimmed.fastq"
REV_IN=${FWD_IN/_1.fastq/_2_trimmed.fastq};

bbmap.sh ref=./data/dog_reference.fasta in1=$FWD_IN in2=$REV_IN out=./output/mapped_to_Dog.sam minid=0.95 -Xmx16g
done;

# use samtools to extract read matches to dog reference genome.
samtools view -F 4 ./output/mapped_to_dog_reference.sam > ./output/mapped_reads.sam
