#!/bin/bash

# Author: Ana Rodriguez Ronchel
#
# Date: 18-11-2020
#
###################################### DESCRIPTION ############################
#
# This script generates a bed file with the coordinates of the genome regions
# that could correspond with DNA loops that were present in the control condition
# but not in the CTCF-deficient condition. For more details about the processing
# of the files, go to the python script "Potential_loop_selection.py".
#
# INPUT:
#       - Arg1: 4 column bed file with lost peaks (chr, star, end, motif strand)
#       - Arg2: 4 column bed file with retained peaks (")
#
# OUTPUT:
#       - A 3 column bed file with potential loops coordinates (chr, start, end)
# 
###################################### REQUIREMENTS ###########################
# 
# The directory must be set to the file where this script is located. 
#
# The parent directoy must contain the next directories: 
#     - Results/Annotated_files: Annotated lost and retained peaks bed files. 
#     - Scripts: this script and the script "Potential_loop_selection.py"
#
# Installed programs: Python
#
##################################### RUN EXAMPLE #############################
#
# ./step2_potential_loop_selection_and_sorting.sh ../Results/Annotated_files/Annotated_Lost_peaks.bed ../Results/Annotated_files/Annotated_Retained_peaks.bed
#
######################################### MAIN ################################

# Arguments:

lost_file=$1
retained_file=$2

# Correct number of arguments asseasment:

if ! [ $# -eq 2 ]; then
	echo -e "\nError. You must give 2 arguments to this program\n" >&2 
	exit 1                 
fi   

# Create the output directoy

mkdir ../Results/Potential_loop_file

# 1. Run the python script 

./Potential_loop_selection.py $lost_file $retained_file

# 2. Sort the resulting bed file 

sort -k1,1 -k2,2n ../Results/Potential_loop_file/potential_loops.bed > ../Results/Potential_loop_file/Potential_loops.bed

# 5. Remove the unsorted file:

rm ../Results/Potential_loop_file/potential_loops.bed








