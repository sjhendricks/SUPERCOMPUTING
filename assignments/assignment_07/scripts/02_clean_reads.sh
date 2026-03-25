#!/bin/bash
set -ueo pipefail

# loop through files
for accession in $(cat ./data/SraRunTable.csv | cut -d',' -f1 | tail -n +2);
do
FWD_IN="./data/raw/${accession}_1.fastq"
REV_IN=${FWD_IN/_1.fastq/_2.fastq}
FWD_OUT=${FWD_IN/.fastq/_trimmed.fastq}
REV_OUT=${REV_IN/.fastq/_trimmed.fastq};

fastp \
--in1 $FWD_IN \
--in2 $REV_IN \
--out1 ${FWD_OUT/raw/clean} \
--out2 ${REV_OUT/raw/clean} \
--json /dev/null \
--html /dev/null \
--n_base_limit 0\
--average_qual 20\;
done;
