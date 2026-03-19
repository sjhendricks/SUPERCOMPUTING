# Assignment 06
Sarah Hendricks

03/18/26

## Task 1
Create designated directories for assignment_06

cd SUPERCOMPUTING/assignments/assignment_06 #(already created)

mkdir -p ./assemblies/assembly_conda ./assemblies/assembly_local ./assemblies/assembly_module

mkdir -p ./data ./scripts

## Task 2
Download data and create script

nano ./scripts/01_download_data.sh

---------------

\#!/bin/bash

set -ueo pipefail

\# download genomic data

wget -P ./data https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1

\# rename data to be usable with flye

mv ./data/'SRR33939694.fastq.gz?download=1' ./data/SRR33939694.fastq.gz

---------------

chmod +x 01_download_data.sh

## Task 3
Download Flye v2.9.6 using local build

Download instructions can be found at: https://github.com/mikolmogorov/Flye/blob/flye/docs/INSTALL.md#local-building-without-installation

nano ./scripts/02_flye_2.9.6_manual_build.sh

---------------

\#!/bin/bash

set -ueo pipefail

\# put this into programs

cd ~/programs

\# manually install flye v2.9.6

git clone https://github.com/fenderglass/Flye

cd Flye

make

cd ~/SUPERCOMPUTING/assignments/assignment_06

\# Add Flye to path

export PATH="$PATH:~/programs/Flye/bin"

---------------

chmod +x ./scripts/02_flye_2.9.6_manual_build.sh

## Task 4
Get flye v2.9.6 with conda

nano ./scripts/02_flye_2.9.6_conda_install.sh

---------------

\#!/bin/bash

set -ueo pipefail

\# setup conda

module load miniforge3

source "$(conda info --base)/etc/profile.d/conda.sh"

\# create environment for flye

mamba create -y -n flye-env flye=2.9.6 -c bioconda

conda activate flye-env

\# check flye version

flye -v

\# document environment using yml

conda env export --no-builds > flye-env.yml

\# deactivate environment

conda deactivate

---------------

chmod +x ./scripts/02_flye_2.9.6_conda_install.sh

## Task 5
Using flye

I used the flye documentation and chatgpt to figure out the best course of action for using flye.

The command I ended up with is:

flye --nano-raw DATA_FILE --meta --out-dir OUT_DIR --threads 6 --genome-size 50k

The data we are using is raw ONT data, so we will use --nano-raw

--meta is used since there may be multiple phages in the data

--out-dir will depend on task 6/desired output folder

--threads 6 determines that we will use 6 threads/cores for the assembly

--genome-size 100k was suggested to be a reasonable estimate for a coliphage genome after some research

More information on the data is found here: https://www.ncbi.nlm.nih.gov/sra/SRX29141853[accn]

## Task 6
Create scripts to run the Task 5 flye command in each environment.

1. Conda environment

nano ./scripts/03_run_flye_conda.sh

---------------

\#!/bin/bash

set -ueo pipefail

\# load miniforge and conda. Activate conda environment

module load miniforge3

source "$(conda info --base)/etc/profile.d/conda.sh"

conda activate flye-env

\# run flye on the data

flye --nano-raw ./data/SRR33939694.fastq.gz --meta --out-dir ./assemblies/assembly_conda --threads 6 --genome-size 100k

\# clean up files

cd ./assemblies/assembly_conda

rm -r 00-assembly 10-consensus 20-repeat 30-contigger 40-polishing

rm assembly_graph.gfa assembly_info.txt assembly_graph.gv params.json

mv assembly.fasta conda_assembly.fasta

mv flye.log conda_flye.log

cd ../..

\# deactivate environment

conda deactivate

---------------

2. Module Environment

nano ./scripts/03_run_flye_module.sh

---------------

\#!/bin/bash
set -ueo pipefail

\# load module environment

module load Flye

\# run flye on the data

flye --nano-raw ./data/SRR33939694.fastq.gz --meta --out-dir ./assemblies/assembly_module --threads 6 --genome-size 100k

\# clean up files

cd ./assemblies/assembly_module

rm -r 00-assembly 10-consensus 20-repeat 30-contigger 40-polishing

rm assembly_graph.gfa assembly_info.txt assembly_graph.gv params.json

mv assembly.fasta module_assembly.fasta

mv flye.log module_flye.log

cd ../..

--------------

3. Local Build

nano ./scripts/03_run_flye_local.sh

--------------

\#!/bin/bash

set -ueo pipefail

\# run flye on the data

flye --nano-raw ./data/SRR33939694.fastq.gz --meta --out-dir ./assemblies/assembly_local --threads 6 --genome-size 100k

\# clean up files

cd ./assemblies/assembly_local

rm -r 00-assembly 10-consensus 20-repeat 30-contigger 40-polishing

rm assembly_graph.gfa assembly_info.txt assembly_graph.gv params.json

mv assembly.fasta local_assembly.fasta

mv flye.log local_flye.log

cd ../..

---------------

## Task 7
Compare results using created log files:

cat ./assemblies/assembly_conda/conda_flye.log | tail -n 10
cat ./assemblies/assembly_module/module_flye.log | tail -n 10
cat ./assemblies/assembly_local/local_flye.log | tail -n 10

Here, all the results are the same, seen below:

1. Conda

2. Module

3. Local

## Task 8
Build a Pipeline

nano pipeline.sh

--------------

\#!/bin/bash

set -ueo pipefail

\# download data

./scripts/01_download_data.sh

\# build flye locally

./scripts/02_flye_2.9.6_manual_build.sh

\# install flye using conda

./scripts/02_flye_2.9.6_conda_install.sh

\# run flye using conda

./scripts/03_run_flye_conda.sh

\# run flye using module

./scripts/03_run_flye_module.sh

\# run flye using local

./scripts/03_run_flye_local.sh

\# compare log files

cat ./assemblies/assembly_conda/conda_flye.log | tail -n 10

cat ./assemblies/assembly_module/module_flye.log | tail -n 10

cat ./assemblies/assembly_local/local_flye.log | tail -n 10

--------------

This pipeline runs all of the scripts created in the previous tasks.
By running ./pipeline.sh in the assignment_06 directory, the above code first runs the 01_download_data.sh script to download the needed fastq file.
Then, the pipeline runs the scripts to build flye locally and install in a conda environment.
Finally, the pipeline runs three scripts that perform a flye command to the downloaded data in each of the environments created previously (including module, which does not need to be created).
As a last step, the pipeline then prints the last 10 lines of each individual log file created in the previous step to STDOUT.

## Reflection
This was one of the most difficult assignments so far.
I ran into the most issues when trying to either run the pipeline or a script that directly followed another.
For example, with 01_download_data, I didn't realize I would need to edit the filename from the download until I tried to use flye on it and then got an error.
The local build went pretty smoothly for this, as did the conda install.
Learning how to use flye also was also a challenge- I relied a lot on the help flag documents they provided on github and chatgpt to explain the meanings in more detail to me.
I had a lot of confusion on the signigicance on the "genome size" parameter, whether that meant the 49.6mb size on the data website or the hinted genome size for Coliphages (the one I ultimately went with).
I chose that one because from my understanding, flye takes in the whole read (49.5mb) that has one or more genomes that overlap throughout the reads, so in this case we are looking for the Coliphage genomes which estimate about 100k.
Flye did also take a longer to run than I had expected, around 3-4 minutes for each environment.
I also had some problems with making sure that the local flye got added to path within the script, I kept getting unbound variable errors there. I ended up just writing the variable to path temporarily versus appending to bashrc, which worked, though it would be worth looking into a more long term solution for this personally.
As for new things learned, I think I still would need to do a lot more research to have a deep understanding of flye, but I feel like I was able to grasp the basics from the research for this assignment.
I think the main thing that I learned here is that there is a lot of patience in getting a pipeline with so many parts to work correctly. 
I spent a lot of time working out small errors in each file, which made me grateful for the set -ueo pipefail aspect so that I didn't have to worry about waiting for the rest of the pipeline to finish after an error.

The method I prefer is definitely module load since it is right there with minimal effort to access for the user. I know this is a special case where the module is actually installed however. I think for the next assignment I might see if conda works in the case of no module because I had the least issues with conda next after module. I had some issues incorporating the flye path to the script for local build (mentioned above) that I would like to avoid in the future!
