#!/bin/bash
set -ueo pipefail

# usage:  ./install_seqkit.sh [install location]
# this location will need to be added to path to use seqkit

# move to directory where you keep programs.
cd $1

# get the seqkit program file
wget https://github.com/shenwei356/seqkit/releases/download/v2.10.1/seqkit_linux_amd64.tar.gz

# unzip the file
tar -xzf seqkit_linux_amd64.tar.gz

# remove the downloaded zipped file
rm seqkit_linux_amd64.tar.gz
