#!/bin/bash
set -ueo pipefail

#download data
./scripts/01_download_data.sh

for file in ./data/raw/*_R1_*
do
./scripts/02_run_fastp.sh $file
done
