Sarah Hendricks
2/11/2026
Assignment 02

-------------------------------------

Task 1:
Created subdirectories in the assignment_02 folder for data, scripts, and outputs.

cd assignments/assignment_02
mkdir ./data ./scripts ./outputs

These directories were created to house any data used in the project, as well as potential scripts or outputs used with the data.

-------------------------------------

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

-------------------------------------

Task 3:
Transfer downloaded files to the HPC using FileZilla.
In FileZilla, navigate to "File" and then "Site Manager..."
Connect to the HPC using the following information:

Host: bora.sciclone.wm.edu
Username: W&M username
Password: W&M password
Port: 22
Protocol: SFTP

Click and drag files from local computer to the folder on the HPC:
~/SUPERCOMPUTING/assignments/assignment_02/data/

Return to HPC in terminal, and locate the recently moved files in the assignment_02/data folder. Check permissions on the file to ensure readability.

cd ~/SUPERCOMPUTING/assignments/assignment_02/data/
ll
chmod 744 GCF_000005845.2_ASM584v2_genomic.fna.gz
chmod 744 GCF_000005845.2_ASM584v2_genomic.gff.gz
# this way the owner has full access to the file, and others can read.

-------------------------------------

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

-------------------------------------

Task 5: 

In the local computer, add aliases.
Note that to use the "--group-directories-first" command, I had to run the following commands:
brew install coreutils

Then, add an alias in the .zshrc so that ls command references the new gls command.

nano ~/.zshrc

Within the .zshrc file, add the following aliases:

alias u='cd ..;clear;pwd;ls -alFh --group-directories-first'
# this alias moves back to the parent directory, clears the screen, lists the directory path, and then lists all files in the directory
# the files are listed including hidden files, longways, with file type symbols and human readable
# the files are also grouped with directories being listed first, then other files
alias d='cd -;clear;pwd;ls -alFh --group-directories-first'
# this alias moves to the previous directory, clears the screen, lists the directory path, and then lists all files in the directory
# the files are listed including hidden files, longways, with file type symbols, and human readable
# the files are also grouped with directories being listed first, then other files
alias ll='ls -alFh --group-directories-first'
# this alias lists files in the current directory
# the files are listed including hidden files, longways, with file type symbols and human readable
# the files are also grouped with directories being listed first, then other files
alias ls='gls'
# This alias allows me to run the --group-directories-first using MacOS

Enabled all new aliases by running the following:
source ~/.zshrc

-------------------------------------

Additionally, while in the HPC, I added the data from assignment_02 to a .gitignore file so that the data is not pushed to github for this project.

touch ~/SUPERCOMPUTING/.gitignore
nano .gitignore

Now, add to the .gitignore file
assignments/assignment_02/data/

-------------------------------------

Reflection:

For this assignment, the biggest barrier was working with ftp and aliases on Mac.
I ran into the same errors with ftp that I think others did as well, but this was cleared up by using the passive command.
For the aliasing issue, I had to install a new package using homebrew and add an alias so that the "--group-directories-first" flag was able to run. 
Otherwise I felt prepared to use FileZilla and check hash digests from working in class.
After assignment 1 I have been trying to use single commands with relative filepaths instead of multiple cd commands, but I sometimes still get confused on the best way to do this and have to test if the command works a few times. 
The last thing I had to be careful about was to really make sure to pull from git hub every time I moved between computers, since I was moving back and forth a lot.
In the future I need to continue to make sure that I remember to pull from github, and I also want to practice using sftp versus filezilla to move files so that I can feel comfortable with both.
