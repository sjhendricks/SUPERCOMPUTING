#!/bin/bash
set -ueo pipefail

# download accession data 
for accession in $(cat ./data/SraRunTable.csv | cut -d',' -f1 | tail -n +2);
do fasterq-dump ${accession}; 
done;

# download dog reference genome
datasets download genome taxon "Canis familiaris" --reference --filename ./ref/dog.zip;
unzip ./ref/dog.zip -d ./ref

