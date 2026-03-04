# Assignment 05
Sarah Hendricks
03/03/2026

## Task 1
Setup for assignment_05 directory.

mkdir -p ./data/raw ./data/trimmed ./log ./scripts

## Task 2
Create a script to download and prepare fastq data.

Before we begin, be sure to nano .gitignore and add assignments/assignment_05/data/


Nano ./scripts/01_download_data.sh


\#!/bin/bash

set -ueo pipefail

\#usage: ./prep_fastq.sh

\# download fastq data

wget https://gzahn.github.io/data/fastq_examples.tar

tar -xvf fastq_examples.tar -C ./data/raw

\# remove  tar file

rm fastq_examples.tar


Run this aftwerwards so that the script is executable.
chmod +x 01_download_data.sh

Also, make sure that the assignment_05/scripts folder is added to the path.
export PATH=$PATH:/sciclone/home/sjhendricks/SUPERCOMPUTING/assignments/assignment_05/scripts

## Task 3
Install and explore fastp tool.

This script installed the latest version (v1.1.0) of fastp.


cd ~/programs

nano install_fastp.sh


\#!/bin/bash

\# download the latest build

wget http://opengene.org/fastp/fastp

chmod a+x ./fastp


Run this to make sure that the script is executable
chmod + x install_fastp.sh

Programs is already in path in .bashrc so no need to add.

## Task 4
Create a script to run fastp.

#!/bin/bash

set -ueo pipefail


FWD_IN=$1

REV_IN=${FWD_IN/_R1_/_R2_}

FWD_OUT=${FWD_IN/.fastq.gz/.trimmed.fastq.gz}

REV_OUT=${REV_IN/.fastq.gz/.trimmed.fastq.gz}


fastp \

--in1 $FWD_IN \ # sets fwd input file

--in2 $REV_IN \ # sets rev input file

--out1 ${FWD_OUT/raw/trimmed} \ # sets the fwd output and puts in data/trimmed

--out2 ${REV_OUT/raw/trimmed} \ # sets the rev output and puts in data/trimmed

--json /dev/null \ # gets rid of the json file output

--html /dev/null \ # gets rid of the html file output

--trim_front1 8 \ # removes first 8 bases from fwd

--trim_front2 8 \ # removes first 8 bases from rev

--trim_tail1 20 \ # removes last 20 bases from fwd

--trim_tail2 20 \ # removes last 20 bases from rev

--n_base_limit 0 \ # discards any read with "N"

--length_required 100 \ # discards reads shorter than 100nt

--average_qual 20 # discards reads <20 avg quality

## TASK 5
Create the pipeline.
