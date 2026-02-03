This is the project directory for Supercomputing assignment 01. This folder contains a mock project structure, with placeholder subdirectories and files for a potential project.

Below are the list of commands used to set up the rest of the subdirectories and files in this assignment_01 folder. 

First, navigate to assignment_01 (or the desired folder).
Then, make the needed subdirectories as seen below.
In this case, I also included a docs subdirectory for any additional documentation that may be needed. When working on projects I wanted to include a space to save documents on data sources, methods of preparing and using data, and any addition documentation/explanations that might be needed to make a project more repeatable and understandable.

mkdir data
mkdir scripts
mkdir output
mkdir docs

Now, move into each subdirectory and create placeholder files or new subdirectories (for examples, and to be able to push to github).
For the data folder, I added folders for raw and clean data as well to make sure that the original data stays unedited.

cd data
mkdir raw
mkdir clean
cd raw
touch test_data_v1.csv
cd ..
cd clean
touch test_data_v1_clean.csv
cd ..

cd ..
cd docs
touch test_documentation.txt
cd ..
cd scripts
touch test_code.py
cd ..
cd output
touch test_results_v1.csv
cd ..

