#!/bin/bash
set -ueo pipefail

# put this into programs
cd ~/programs

# manually install flye v2.9.6
git clone https://github.com/fenderglass/Flye
cd Flye
make

cd ~/SUPERCOMPUTING/assignments/assignment_06

# Add Flye to path
export PATH="$PATH:~/programs/Flye/bin"
