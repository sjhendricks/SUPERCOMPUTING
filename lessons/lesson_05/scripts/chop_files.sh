#!/bin/bash
set -ueo pipefail

# set project directory where files are found
#MAIN_DIR="/sciclone/home/sjhendricks/SUPERCOMPUTING/lessons/lesson_05"

# go to that location
#cd ${MAIN_DIR}

for FWD in ${DATA_DIR}/*_R1_*
do
REV=${FWD/_R1_/_R2_}
OUT=${FWD%_L001_R1_sample.fastq}_interleaved_chop_${1}.fastq
echo ${FWD} ${REV} ${OUT};
./scripts/interleave_chop.sh ${FWD} ${REV} ${OUT} ${1}
done
