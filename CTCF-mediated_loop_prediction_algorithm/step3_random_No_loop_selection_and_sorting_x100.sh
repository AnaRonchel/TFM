#!/bin/bash

# Author: Ana Rodriguez Ronchel
#
# Date: 18-11-2020
#
###################################### DESCRIPTION ############################
#
# This script generates a bed file with same regions size that loop file
# generated in the step2 but with random location. 
#
# INPUT:
#       - Arg1: 3 column bed file with predicted loop regions (chr, star, end)
#
# OUTPUT:
#       - 3 column bed file with regions with the same size but that are not
#         potential loops (chr, start, end). It have 100 times more regions
#         than the input file.
# 
###################################### REQUIREMENTS ###########################
# 
# The directory must be set to the file where this script is located. 
#
# The parent directoy must contain the next directories:
#     - Data: a file with the size of each chromosome of the mm10 genome. 
#     - Results/Potential_loop_file: predicted loops regions bed file. 
#
# Installed programs: bedtools
#
##################################### RUN EXAMPLE #############################
#
# ./step3_random_No_loop_selection_and_sorting_x100.sh ../Results/Potential_loop_file/Potential_loops.bed ../Data/mm10.chrom.sizes
#
######################################### MAIN ################################

# Arguments:

potential_loop_file=$1
chrom_sizes=$2

# Correct number of arguments asseasment:

if ! [ $# -eq 2 ]; then
	echo -e "\nError. You must give 2 argument to this program\n" >&2 
	exit 1                 
fi   

# Create the output directoy

mkdir ../Results/No_loop_file_x100

# 1. Run the bedtools comand 100 times and append the result to the same output file:

for i in {1..100}
do
    bedtools shuffle -i $potential_loop_file -g $chrom_sizes -seed $i >> ../Results/No_loop_file_x100/no_loops.bed
done


# 2. Sort the resulting bed file 

sort -k1,1 -k2,2n ../Results/No_loop_file_x100/no_loops.bed > ../Results/No_loop_file_x100/No_loops.bed

# 5. Remove the unsorted file:

rm ../Results/No_loop_file_x100/no_loops.bed








