#!/bin/bash

# Author: Ana Rodriguez Ronchel
#
# Date: 18-11-2020
#
###################################### DESCRIPTION ############################
#
# This script annotates a bed file with information about the coordinated 
# expression score (CES) of each region and the number of genes within it.
# CES is calculated as the mean ponderated logFC of the genes inside the
# regions. More details can be foun in the script 
#
# INPUT:
#       - Arg1: Differential expression annotated genes file obtained with the
#               DESeq2 program in the RNA-Seq analysis.
#       - Arg2: Bed file with the loop or no-loop regions
#       - Arg3: YES if you want to annotate the loop file or NO if you want
#               to annotate the no-loop file. 
#
# OUTPUT:
#       - 5 column bed file with the loop or no-loop regions coordinates, the
#         Coordinated Expression Score (CES) of each region and the number of 
#         genes within them (chr, start, end, CES, n_genes)
# 
###################################### REQUIREMENTS ###########################
# 
# The directory must be set to the file where this script is located. 
#
# The parent directoy must contain the next directories: 
#     - Results/Potential_loop_file or Results/No_loop_file: with the loop
#        or no loop regions determined in the previous step. 
#     - Scripts: this script and the script "Region_CES_annotation.py"
#
# Installed programs: Python
#
##################################### RUN EXAMPLE #############################
#
# For loops:
# ./step4_region_CES_annotation.sh gene_exp_from_galaxy.csv Potential_loops.bed YES
# 
# For No loops:
# ./step4_region_CES_annotation.sh gene_exp_from_galaxy.csv No_loops.bed NO
#
######################################### MAIN ################################

# Arguments:

Expression_file=$1
Loops_or_not_file=$3

# Correct number of arguments asseasment:

if ! [ $# -eq 3 ]; then
	echo -e "\nError. You must give 3 arguments to this program\n" >&2 
	exit 1                 
fi   

# Create the output directoy

if [ $Loops_or_not_file = "YES" ]; then
    mkdir ../Results/Potential_loop_file_annotated
    Loops_file=../Results/Potential_loop_file_100kb/$2
elif [ $Loops_or_not_file = "NO" ]; then
    mkdir ../Results/No_loop_file_annotated
    Loops_file=../Results/No_loop_file_x100_random_100kb/$2
else
    echo -e "The Arg3 should be YES or NO"
fi 

# Delete lines with NA's in the adj p-value column.

awk -F'\t' -v OFS='\t' '{ if ($7!="NA"){ print $0 } }' ../Data/$Expression_file > ../Data/No_NA_$Expression_file

# Run the python script

./Region_CES_annotation.py ../Data/No_NA_$Expression_file $Loops_file $Loops_or_not_file









