# Assignment 04
Sarah Hendricks

2/25/2026

## Task 1
Create Program directory in the HPC (completed prior to assignment). 

mkdir ~/programs

cd ~/programs

## Task 2
Download and unpack the gh "tarball" file.

To find file visit the following site:

https://github.com/cli/cli

Navigate to README.md on the site. Then scroll down to locate "releases" hyperlink.

Find the version 2.74.2 (page 3 when I looked) on the releases page.

Under assets, locate the GitHub CLI 2.74.2 linux amd64 file that is needed. Linked here:

https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz

Download file:

wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz

Unpack file:

tar -xzvf gh_2.74.2_linux_amd64.tar.gz

## Task 3
Building install_gh.sh script to complete the above.


\#!/bin/bash

set -ueo pipefail

\#get github version

wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz

\#unpack file

tar -xzvf gh_2.74.2_linux_amd64.tar.gz

\#remove zipped file

rm gh_2.74.2_linux_amd64.tar.gz


After running the script, be sure to make sure it is executable.


chmod +x install_gh.sh

## Task 4
Now, add the output gh file to the path, by using nano ~/.bashrc

export PATH=$PATH:/sciclone/home/sjhendricks/programs/gh_2.74.2_linux_amd64"

## Task 5
Run gh auth login to setup Github. This was accomplished in class.

gh auth login

- hit 'enter' to select 'GitHub.com'
- hit 'enter' to select 'HTTPS'
- hit 'enter' or type 'Y' to say "yes"
- choose log in with token
enter token created in assignment_00


## Task 6
Installation script for seqtk.


On the site https://github.com/lh3/seqtk , locate the installation commands in the introduction section.


git clone https://github.com/lh3/seqtk.git;
cd seqtk; make


Now, using nano install_seqtk.sh


\#!/bin/bash

set -ueo pipefail

\#install seqtk

git clone https://github.com/lh3/seqtk.git;

cd seqtk; make

\#instructions to add directory

/sciclone/home/sjhendricks/programs

echo "export PATH=$PATH:/sciclone/home/sjhendricks/programs/seqtk" >> ~/.bashr


Also, make sure to run chmod +x install_seqtk.sh to make executable.

## Task 7
Experiment with seqtk. 

Seqtk has a nice feature where if you type in a command (e.g. seqtk subseq) with no input, it will give you some of the common flags or uses for the command.
The command that ended up being important for later in the assignment is comp, which provides a lot of summary information about the file, such as the name and length, as well as number of each nucleotide, among other things.
Reverse complement (seqtk seq -r in.fq > out.fq) is also useful, so you don't have to use tr to accomplish reverse like we discussed in class. Also, since this works with FASTQ files, there is also a command to convert between FASTA/FASTQ files, which is convenient.

## Task 8
Create summarize_fasta.sh

Move to assignment_04 directory.

cd ~/SUPERCOMPUTING/assignments/assignment_04/scripts

(prior to this assignment, ran mkdir ./data ./outputs ./scripts in assignment_04 directory)

Now, nano summarize_fasta.sh


\#!/bin/bash

set -ueo pipefail

\# save fasta file name as a variable (input)

file=${1}

\# shorten file name

short=$(basename $file)

\# calculate and save total number of sequences

seqs=$(grep "^>" ${file} | wc -l)

\# calculate and save total number of nucleotides

nucleotides=$(grep -v "^>" ${file} |tr -d "\n" | wc -c)

\# table of sequence names and lengths

table=$(seqtk comp ${file} | cut -f1,2)


echo "Total Number of Sequences in ${short}"

echo "${seqs}"

echo "Total Number of Nucleotides in ${short}:"

echo "${nucleotides}"

echo "All Sequence names and lengths:"

echo "${table}"


## Task 9
Run summarize_fasta.sh on multiple files (loop)

After some issues with unzipping described in the reflection, I decided to just make a copy of the file used in a previous assignment, like below:

wget https://gzahn.github.io/data/GCF_000001735.4_TAIR10.1_genomic.fna.gz

gunzip GCF_000001735.4_TAIR10.1_genomic.fna.gz

cp GCF_000001735.4_TAIR10.1_genomic.fna.gz genome_copy_01.fna

cp GCF_000001735.4_TAIR10.1_genomic.fna.gz genome_copy_02.fna


Now, run summarize_fasta.sh on the three files in a loop.

for file in *.fna; do summarize_fasta.sh $file;done


After this, make sure to add assignments/assignment_04/data/ to the .gitignore

## Reflection

I had some issues with unzipping downloaded .gz files, so I will describe my process below.


For this, I attempted to get files from GenBank using the following process:

Visit here to locate genomes: https://www.ncbi.nlm.nih.gov/datasets/genome/

Search for wanted genomes, here tried:
Caenorhabditis elegans, brassica oleracea var. italics, and pyrus communis (c elegans, broccoli, pear)

Used genomes WBcel235, ASM3464025v1,drPyrComm1.1 respectively.

Went to ftp page for each genome, found file ending in  _genomic.fna.gz to transfer.


From here, used ftp on local machine, assignment_04/data directory, similar to assignment_02:
(note, logged into ftp separate times for each genome using the same beginning commands)

ftp ftp.ncbi.nlm.nih.gov

anonymous

Password: email

passive

\#repeat the beginning for each of these, follwed by 'bye'

cd genomes/all/GCF/000/002/985/GCF_000002985.6_WBcel235/

get GCF_000002985.6_WBcel235_genomic.fna.gz

cd genomes/all/GCA/034/640/255/GCA_034640255.1_ASM3464025v1/

get GCA_034640255.1_ASM3464025v1_genomic.fna.gz

cd genomes/all/GCF/963/583/255/GCF_963583255.1_drPyrComm1.1

get GCF_963583255.1_drPyrComm1.1_genomic.fna.gz

bye


Then, used filezilla to move downloaded files to the HPC, same directory.

However, when used gunzip 'filename' for each file, got an error. I couldn't figure out a workaround for this, I attempted making sure that the ftp was set to 'binary', but it might have been worth trying to use wget instead here, since nothing else seemed to work.
Eventually, I decided to just make a copy of the file used in a previous assignment, like I described above.

Other than this the only thing I ran into was trying to figure out the best way to create the table for the summarize_fasta.sh script.
At that point I hadn't figured out the comp command from seqtk, so it took some googling (e.g. "seqtk how to make a table") to find that command, which was really helpful.

I was surprised that I could pass some of the functions as variables in the summarize_fasta.sh file, specifically the table.
I think I had assumed that a variable could only be one line/value, which I'm not sure why I thought this, since we have assigned files to variables before.
Either way, it makes working out the script a lot simpler/clearer to be able to assign a whole table to a variable.

As for $PATH, that is essentially the list of locations that the shell will check when attempting to run a script/program.
By adding to the path with "export PATH=$PATH ..." to the .bashrc, we are adding to the list of places that will be checked, essentially making sure that the shell is able to find a specific program/script we want to run.
