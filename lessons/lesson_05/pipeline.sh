#!/bin/bash
set -ueo pipefail

# pipeline is the conductor - runs modular scripts in order
# usage: ./pipeline.sh [N bases to chop]

DATA_DIR="/sciclone/scr10/gzdata440/lesson_05/data/"

# chop files
./scripts/chop_files.sh ${1}

# run stats
./scripts/get_stats.sh
