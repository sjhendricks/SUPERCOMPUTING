Sarah Hendricks
2/11/2026
Assignment 02

Task 1:
Created subdirectories in the assignment_02 folder for data, scripts, and outputs.

mkdir ./data ./scripts ./outputs

Task 2:
Downloaded two data files from NCBI using command-line ftp. 

ftp ftp.ncbi.nlm.nih.gov

Log in as anonymous using email as password. Now, move to folder containing the wanted data.

passive #to ensure ability to download files on Mac
cd genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/
ls # look around to see information on files

Now, download the files that are needed. These files ended up in the home directory of my local computer.

get GCF_000005845.2_ASM584v2_genomic.fna.gz
get GCF_000005845.2_ASM584v2_genomic.gff.gz
bye #exit after downloading files.

Task 3:
Transfer downloaded files to the HPC using FileZilla.
In FileZilla, navigate to "File" and then "Site Manager..."
Connect to the HPC using the following information:

Host: bora.sciclone.wm.edu
Username: your W&M username
Password: your W&M password
Port: 22
Protocol: SFTP

Click and drag files from local computer to the folder:
~/SUPERCOMPUTING/assignments/assignment_02/data/

Return to HPC in terminal, and locate the recently moved files in the assignment_02/data folder. Check permissions on the file to ensure readability.

ll
chmod 744 GCF_000005845.2_ASM584v2_genomic.fna.gz
chmod 744 GCF_000005845.2_ASM584v2_genomic.gff.gz
# this way the owner has full access to the file, and others can read.

Task 4:
Check hash digests on each file on local and HPC versions.

In the local machine, where the downloaded original files are (home directory). 

cd
md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz
# result: e1b894042b53655594a1623a7e0bb63f  GCF_000005845.2_ASM584v2_genomic.fna.gz
md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz
# result: 494dc5999874e584134da5818ffac925  GCF_000005845.2_ASM584v2_genomic.gff.gz

Now, log into HPC and confirm hash digests there.

cd ~/SUPERCOMPUTING/assignments/assignment_02/data
md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz   
# result: e1b894042b53655594a1623a7e0bb63f  GCF_000005845.2_ASM584v2_genomic.fna.gz
md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz
# result: 494dc5999874e584134da5818ffac925  GCF_000005845.2_ASM584v2_genomic.gff.gz

Note that the hash digests are the same in both computers, so the files were transferred without any edits to the original.

Task 5:

In the local computer, add aliases.

nano ~/ .zshrc

Within the .zshrc file, add the following aliases:

alias u='cd ..;clear;pwd;ls -alFh --group-directories-first'
# this alias moves back to the parent directory, clears the screen and then lists all files
# the files are listed including hidden files, longways, with file type symbols and human readable
# 
alias d='cd -;clear;pwd;ls -alFh --group-directories-first'
# this alias moves
#
alias ll='ls -alFh --group-directories-first'
# this alias lists files in the current directory
# the files are listed including hidden files, longways, with file type symbols and human readable
alias ls='gls'
# This alias allows me to run the --group-directories-first using MacOS


Enabled all  aliases by running the following:
source ~/.zshrc

