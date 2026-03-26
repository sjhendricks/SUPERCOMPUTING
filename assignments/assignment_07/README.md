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
	#SBATCH -o /sciclone/scr10/sjhendricks/assignment_07_%j.out #STDOUT to file (%j is jobID)
	#SBATCH -e /sciclone/scr10/sjhendricks/assignment_07_%j.err #STDERR to file (%j is jobID)


	./scripts/01_download_data.sh
	./scripts/02_clean_reads.sh
	./scripts/03_map_reads.sh
	
## Task 8
Interpret Results

This is also covered in the reflection below, however the slurm script that I was able to submit ended up failing since it could not locate samtools. I have a proposed solution below for this error.
The other thing I noticed from the .err file is that fasterq-dump failed after it could not find data for some of the accessions. So, this pipeline only executed on about 5 accessions, so in the future I will need to locate different accessions to use that actually have data.

## Reflection:
I struggled a lot with this assignment. One of the biggest causes for confusion with this is how to determine what processes are OK to run on the login node and what needs to be sent in a job to slurm.
I also was not very sure about the files I had selected (rightfully so) but was able to find in a previous lecture recording some information about searching on SRA. In the end, with the files that I had chosen, only four of them downloaded since fasterq-dump quit after encountering three accessions with no data in them, which is strange because each had data when I was looking at them on the website.
For the future, I included new search terms that might yield better results to download in the first place.
For the task contene, the downloading of the data itself through fasterq-dump was one of the processes I was concerned about running on the login node. I ended up testing my scripts by downloading only two of the files, and then only using the first 10 lines from each.
This was able to run on every step except for bbmap, which did not run (I think due to the size of the files still). All of my data and outputs were routed to scr10 for this assignment. The fastp usage in Task 3 was fairly straightforward, since we have worked with fastp before, so I felt that aside from making sure the filepaths are correct, this task was not too bad.
As I mentioned before, for task 4, the bbmap.sh test with smaller files still canceled when I attempted to run it on the login node, so I moved to the slurm script for this so that it would at least execute.
The next step was downloading samtools, which I thought went correctly. However, my pipeline ended up failing because it could not locate samtools. I think the mistake I made here is that I didn't actually build samtools, I just installed it. I attempted the code below after creating the ~/programs/samtools directory, but encountered a permission denied error. I think maybe the best route to go for samtools here would be installing it to a conda environment/bbmap-env instead to work around these issues.
	
	cd samtools-1.23.1    # and similarly for bcftools and htslib
	./configure --prefix=~/programs/samtools
	make	
	make install

The final step for the pipeline is to create the slurm script and send it in. 
I felt that my downloading/qc scripts both were working after the tests on the smaller data, and submitting it to slurm would mean the bbmap should be able to run as well.
In the end, the slurm script failed about 4 hours in, as I mentioned before. When I was looking for the .err file to investigate why the slurm job failed, I also noticed that I needed to be more specific about where my output and error files were going, as these ended up in my assignment_07 folder instead of scr10. I changed the slurm script so that these will go to the right place in the future. 
Within the .err file, aside from the samtools error, at this point I also noticed the fasterq-dump failure that resulted in only a few of the files being downloaded. I think this could be amended by choosing different accessions, perhaps with the new search terms I mentioned above.

Overall, the recorded lecture videos on the google drive and the lesson_07 document were really helpful to get going on the right track, however I feel that I really need to gain more confidence when it comes to determining what processes can and cannot be run on the login node, as well as determining the optimal parameters that can be used for slurm requests.
I also don't think I realized just how long that some of these processes could take (bbmap especially).
