# Assignment 07
3/23/26
Sarah Hendricks

## Task 1
Set up directory for assignment 07.
	mkdir -p data/{clean,dog_reference,raw}

	mkdir ./output ./scripts

## Task 2
Download Sequence Data

Go to https://www.ncbi.nlm.nih.gov/sra/ to locate the accessions needed.

In the search bar, enter the following:
	shotgun metagenome AND illumina[Platform] AND WGS[Strategy] 

I chose the first 12 accessions listed, 
	Accession: ERX16283665
	Accession: ERX16283657
	Accession: ERX16283693
	Accession: ERX16283695
	Accession: ERX16283669
	Accession: ERX16283697
	Accession: ERX16283667
	Accession: ERX16283672
	Accession: ERX16283673
	Accession: ERX16283678
	Accession: ERX16283652
	Accession: ERX16283676
Select all of these files, and then click Send to: and select Run Selector.

Make sure that the total is 12, and select metadata to download the metadata csv. Mine downloaded directly to my downloads folder.

Use FileZilla to transfer the metadata csv to the hpc. I placed the csv in the following location:
	/sciclone/home/sjhendricks/SUPERCOMPUTING/assignments/assignment_07/data

Now, create a script that will download all the needed data for the assignment.

Before creating this script, ensure that sratoolkit and NCBI's command-line tool are installed.

This was done prior to the assignment, and instructions to do so are here:
	https://github.com/ncbi/sra-tools/wiki/02.-Installing-SRA-Toolkit
	https://www.ncbi.nlm.nih.gov/datasets/docs/v2/command-line-tools/download-and-install/
These are located in the ~/programs directory on the hpc.

From the assignment_07 directory (/sciclone/home/sjhendricks/SUPERCOMPUTING/assignments/assignment_07)
	nano ./scripts/01_download_data.sh

	#!/bin/bash
	set -ueo pipefail

	# download accession data 
	for accession in $(cat ./data/SraRunTable.csv | cut -d',' -f1 | tail -n +2);
	do fasterq-dump ${accession}; 
	done;

	# download dog reference genome
	datasets download genome taxon "Canis familiaris" --reference --filename ./ref/dog.zip;
	unzip ./ref/dog.zip -d ./ref

## Task 3
