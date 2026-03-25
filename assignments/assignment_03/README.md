# Assignment 03
Sarah Hendricks

2/18/2026

## Task 1
First, set up the folders within the assignment 03 folder.

	mkdir ./data ./scripts ./outputs
	cd ./data

This project will be focused in the ./data folder, working with a fasta sequence file and unix tools.

## Task 2
Next, download and unzip the fasta sequence file using the following commands:

	wget https://gzahn.github.io/data/GCF_000001735.4_TAIR10.1_genomic.fna.gz
	gunzip GCF_000001735.4_TAIR10.1_genomic.fna.gz

## Task 3
Then, answer the questions below with the following commands:

Before answering, assign the filename to a variable for easier referencing.

	seq="GCF_000001735.4_TAIR10.1_genomic.fna"

1. How many sequences are in the FASTA file? (answer=7)

	grep "^>" ${seq} | wc -l

2. What is the total number of nucleotides (not including header lines or newlines)? (answer=119,668,634)

	grep -v "^>" ${seq} |tr -d "\n" | wc -c

3. How many total lines are in the file? (answer=14)

	cat ${seq} | wc -l

4. How many header lines contain the word "mitochondrion"? (answer=1)

	grep "^>" ${seq} | grep "mitochondrion" | wc -l

5. How many header lines contain the word "chromosome"? (answer=5)

	grep "^>" ${seq} | grep "chromosome" | wc -l

6. How many nucleotides are in each of the first 3 chromosome sequences? (answer=30,427,672   19,698,290  23,459,831)

	cat ${seq} | grep -v "^>" | head -n 1 | wc -c
	cat ${seq} | grep -v "^>" | head  -n 2 | tail -n 1 | wc -c
	cat ${seq} | grep -v "^>" | head  -n 3 | tail -n 1 | wc -c

7. How many nucleotides are in the sequence for 'chromosome 5'? (answer=26,975,503)

	cat ${seq} | grep -v "^>" | head  -n 5 | tail -n 1 | wc -c

8. How many sequences contain "AAAAAAAAAAAAAAAA"? (answer=1)

	grep -v "^>" ${seq] | grep "AAAAAAAAAAAAAAAA" | wc -l

9. If you were to sort the sequences alphabetically, which sequence (header) would be first in that list? (answer=>NC_000932.1...)

	grep "^>" ${seq} | sort | head -n 1

10. How would you make a new tab-separated version of this file, where the first column is the headers and the second column are the associated sequences? (show the command(s))

	>NC_003070.9 Arabidopsis thaliana chromosome 1 sequence    ccctaaaccctaaaccctaaaccctaaacctctG...
	>NC_003071.7 Arabidopsis thaliana chromosome 2, partial sequence    NNNNNNNNNNNNNNNNNNNNNNN...
    ... etc.


	paste <(grep "^>" ${seq}) <(grep -v "^>" ${seq}) > tab_sep_seq

## Extra Steps
For this section, I went back from the assignment_03/data folder to the repository .gitignore file (cd ../../..) and added the following using nano:

	assignments/assignment_03/data/

so that the data from this project is not pushed to github.

I did however use filezilla to transfer the data that was used in this assignment from the HPC to my local computer so that I have access to it on both machines.

## Reflection
I tried to follow closely to what we did in class for this assignment. One of the biggest things I ran into was that it was difficult to test each part of the whole command, since the genome sequences are so many characters that the terminal would become so slow if I accidentally read the file to the screen. So, I tried to either work with mostly the genome header lines or pipe everything to word/line counts since that was able to print without buffering. When possible, I would work with each section of the final command that I ended up with to make sure each part was functioning correctly before adding another section. For the questions themselves, I had to work out question 2 on how to make sure that I wasn’t counting line breaks, but I think that tr works well here (I would just want to make sure I am careful in the future about using tr -d and deleting characters). One thing that I did to make the overall process a little easier was to assign the filename to a variable, so that I could use that repeatedly instead of the entire filename. For commands that were similar I was also able to reuse some of the same code and just edit the head/tail commands in order to get the result for the line that was needed. The last thing I did for this assignment was to make sure that the data folder in the assignment_03 directory was entered into the .gitignore file for the Supercomputing repository. I moved the genome data file for this assignment to my local computer using filezilla as well so that I have access without pushing the data to github.

As for using these skills in computing work, in general being able to manipulate and search for specific patterns in really large text files without having to do so manually is both time-saving and could potentially reduce the chance of missing instances of the pattern. Having the knowledge of these tools to organize data within files and also move any changes or edits into a new file so that the original data stays unedited is also really important. I have used similar functions in python to clean/process data (string methods), so being able to do this really quickly in terminal is definitely useful.
