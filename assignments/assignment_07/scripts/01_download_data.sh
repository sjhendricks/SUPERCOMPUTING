#!/bin/bash
set -ueo pipefail

# download accession data 
for accession in $(cat ./data/SraRunTable.csv | cut -d',' -f1 | tail -n +2);
do fasterq-dump ${accession} -O /sciclone/scr10/sjhendricks/assignment_07/data/raw;
done;

# download dog reference genome
datasets download genome taxon "Canis familiaris" --reference --filename ./data/dog_reference/dog.zip;
unzip ./data/dog_reference/dog.zip -d ./data/dog_reference

