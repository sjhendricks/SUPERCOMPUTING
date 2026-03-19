#!/bin/bash
set -ueo pipefail

# put this into programs
cd ~/programs

# manually install flye v2.9.7
git clone https://github.com/fenderglass/Flye
cd Flye
make

cd ~/SUPERCOMPUTING/assignments/assignment_06

