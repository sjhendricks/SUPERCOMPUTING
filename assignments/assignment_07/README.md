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

	shotgun metagenome data

(After researching this a better search would likely be something like: RANDOM[Selection] AND illumina[Platform] AND WGS[Strategy] but at this point I had alread begun to work with the acessions I downloaded)
I chose the first 12 accessions listed, which can be found in the data/SraRunTable.csv file.

Select all of these files, and then click Send to: and select Run Selector

Make sure that the total is 12, and select metadata to download the metadata csv. Mine downloaded directly to my downloads folder.

Use FileZilla to transfer the metadata csv to the hpc. I placed the csv in the following location:

	/sciclone/home/sjhendricks/SUPERCOMPUTING/assignments/assignment_07/data

Now, create a script that will download all the needed data for the assignment.

Before creating this script, ensure that sratoolkit and NCBI's command-line tool are installed.

This was done prior to the assignment, and instructions to do so are here:

	https://github.com/ncbi/sra-tools/wiki/02.-Installing-SRA-Toolkit
	https://www.ncbi.nlm.nih.gov/datasets/docs/v2/command-line-tools/download-and-install/These are located in the ~/programs directory on the hpc.

From the assignment_07 directory (/sciclone/home/sjhendricks/SUPERCOMPUTING/assignments/assignment_07)
	
	nano ./scripts/01_download_data

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

I am working out of the scr10 space as the files are fairly large.
## Task 3
Cleaning up the raw reads.

This will be done by creating another script.

	nano ./scripts/02_clean_reads.sh


	#!/bin/bash
	set -ueo pipefail

	# loop through files
	for accession in $(cat ./data/SraRunTable.csv | cut -d ',' -f1 | tail -n +2);
	do
	FWD_IN="/sciclone/scr10/sjhendricks/assignment_07/data/raw/${accession}_1.fastq"
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
	--average_qual 20;
	done;

This script loops through the files once more, and the uses fastp as a qc tool.

## Task 4 and 5
Mapping the clean reads to the dog genome using bbmap. Then, extract reads that matched dog genome.

This will be located in another script.

	nano ./scripts/03_map_reads.sh

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
	
## Task 6
Create pipeline slurm script.

	cd ~/SUPERCOMPUTING/assignments/assignment_07
	nano assignment_07_pipeline.slurm

	#!/bin/bash
	#SBATCH --job-name=assignment_07
	#SBATCH --nodes=1 # how many physical machines in the cluster
	#SBATCH --ntasks=1 # how many separate 'tasks' (stick to 1)
	#SBATCH --cpus-per-task=20 # how many cores (bora max is 20)
	#SBATCH --time=0-20:00:00 # d-hh:mm:ss or just No. of minutes
	#SBATCH --mem=120G # how much physical memory (all by default)
	#SBATCH --mail-type=FAIL,BEGIN,END # when to email you
	#SBATCH --mail-user=sjhendricks@wm.edu # who to email
	#SBATCH -o assignment_07_%j.out #STDOUT to file (%j is jobID)
	#SBATCH -e assignment_07_%j.err #STDERR to file (%j is jobID)


	./scripts/01_download_data.sh
	./scripts/02_clean_reads.sh
	./scripts/03_map_reads.sh
	
## Task 8
Interpret Results

## Reflection:

