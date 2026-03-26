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
