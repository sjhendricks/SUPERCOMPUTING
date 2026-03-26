#!/bin/bash
set -ueo pipefail

SCR_DIR="/sciclone/scr10/sjhendricks/assignment_07"
DATA_DIR="${SCR_DIR}/data/raw"
REF_DIR="${SCR_DIR}/data/dog_reference"

# download accession data 
for accession in $(cat ./data/SraRunTable.csv | cut -d ',' -f1 | tail -n +2);
do
if [ ! -f "${DATA_DIR}/${accession}_1.fastq" ]; then
	# if the file doesn't exist, then download them.
	fasterq-dump ${accession} -O ${DATA_DIR} -t ${DATA_DIR};
fi
done

# download dog reference genome
if [ ! -f "${REF_DIR}/dog.zip" ]; then
	datasets download genome taxon "Canis familiaris" --reference --filename "${REF_DIR}/dog.zip";
	unzip "${REF_DIR}/dog.zip" -d "${REF_DIR}"
fi
