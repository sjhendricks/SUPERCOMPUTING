# Assignment 05
Sarah Hendricks
03/03/2026

## Task 1
Setup for assignment_05 directory.

mkdir -p ./data/raw ./data/trimmed ./log ./scripts

## Task 2
Create a script to download and prepare fastq data.

This script downloads fastq files from github and extracts the contents into the raw data folder created in the previous step.

Before we begin, be sure to nano .gitignore and add assignments/assignment_05/data/


Nano ./scripts/01_download_data.sh

---------------

\#!/bin/bash

set -ueo pipefail

\#usage: ./prep_fastq.sh

\# download fastq data

wget https://gzahn.github.io/data/fastq_examples.tar

tar -xvf fastq_examples.tar -C ./data/raw

\# remove  tar file

rm fastq_examples.tar

---------------

Run this aftwerwards so that the script is executable.

chmod +x 01_download_data.sh

Also, make sure that the assignment_05/scripts folder is added to the path.

export PATH=$PATH:/sciclone/home/sjhendricks/SUPERCOMPUTING/assignments/assignment_05/scripts

## Task 3
Install and explore fastp tool.

This script installs the latest version (v1.1.0) of fastp from github, using code provided on this website:https://github.com/OpenGene/fastp/blob/master/README.md#get-fastp


cd ~/programs

nano install_fastp.sh

---------------

\#!/bin/bash

\# download the latest build

wget http://opengene.org/fastp/fastp

chmod a+x ./fastp

---------------

Run this to make sure that the script is executable

chmod +x install_fastp.sh

Programs is already in path in .bashrc from a previous assignment so no need to add.

## Task 4
Create a script to run fastp.

cd ~/SUPERCOMPUTING/assignments/assignment_05/scripts

nano 02_run_fastp.sh
---------------
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

---------------

Run this to make sure that the script is executable

chmod +x 02_run_fastp.sh

## TASK 5
Create the pipeline.

cd ~/SUPERCOMPUTING/assignments/assignment_05

nano pipeline.sh

---------------

\#!/bin/bash

set -ueo pipefail

\#download data

./scripts/01_download_data.sh

\#run fastp on data

for file in ./data/raw/*_R1_*

do

./scripts/02_run_fastp.sh $file

done

---------------

Run this to make sure that the script is executable

chmod +x pipeline.sh

Also, make sure that the assignment_05 folder is added to the path.

nano ~/.bashrc

export PATH=$PATH:/sciclone/home/sjhendricks/SUPERCOMPUTING/assignments/assignment_05



This pipeline runs both of the scripts created in the previous tasks. 
By running ./pipeline.sh in the assignment_05 directory, the above code first runs first the 01_download_data.sh script to download and prepare the fastq files.
Then, the script includes a for loop that executes 02_run_fastp.sh on each forward file (includes \_R1_ in the name) in the data/raw folder (previously downloaded there by 01_download_data.sh).
The 02_run_fastp.sh script places the processed data in data/trimmed to avoid modifying the original data.

## Reflection

For this assignment, I felt pretty confident in writing scripts since we have worked so much in class.
The main issues I ran into for this assignment were making sure the data ended up in the correct folder.
The hint given helped a lot- at first I didn’t consider that since the input is a file name it includes data/raw in the variables.
As for new things I learned with this assignment, the fastp tool definitely seems like it would be useful for processing genomic data. 
I was also glad for the chance to practice using parameter expansion for creating slightly different variable names. 
This especially with the for loop, as it helped me to see the way you can apply fastp to multiple files and change the output to be what you want and go where you want them to.
The flags for fastp are also really useful as you can make sure to send the json and html files away to dev/null and fine tune fastp to do exactly what you need.
Finally, for why to separate a process into multiple different specific scripts and then run them all in a pipeline: this increases the modularity of a project.
By separating a process into scripts that each do one job, it is easier to locate a potential issue in the pipeline ( I found this out when working on the assignment, as it let me know when there was an issue with the 02 file and I could easily go fix it, I know this won’t always be the case however). The cons to this are that in a large process there could be many scripts involved. 
Another issue is we have run into with using separate scripts is if one script requires an argument to be passed, it takes some decisions on how you want that to be involved in the pipeline since a lot of the time variables don’t carry over into subshells.
