#!/bin/bash
set -ueo pipefail

# download and prepare data
# makes a directory for data with subdirectories raw and trimmed.
# uses wget to download data
# moves data to the new /data/raw
# extracts the data from the .tar.gz file
./scripts/01_prep_data.sh

# gets stats on the downloaded data
# uses seqkit to find the files in data raw, ends with fastq
# outputs the stats to a new file
./scripts/02_get_stats.sh

# cleans up!
# removes .gz file from data/raw
./scripts/02_cleanup.sh

