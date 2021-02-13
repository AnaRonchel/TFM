#!/bin/bash

# Author: Ana Rodriguez Ronchel
#
# Date: 12-01-2021
#
###################################### DESCRIPTION ############################
#
# Select the common elements from 2 files
#
# INPUT:
#   - Arg 1: gene list from the previous step (genes in loops regions OE and UE)
#   - Arg 2: gene list from RNA-Seq analysis (DEGs) 
#
# OUTPUT:
#   - 1 column file with common gene names. 
# 
###################################### REQUIREMENTS ###########################
# 
# The directory must be set to the file where this script is located. 
#
# The parent directoy must contain the next directories: 
#     - Data: DEG list sorted (from promoter region analysis)
#     - Scripts: this script
#     - Results/OE_and_UE_regions_annotated/: list of genes in loop OE and UE
#
##################################### RUN EXAMPLE #############################
#
# ./step7_DEGs_in_loop_regions.sh loops_genes.txt sorted_DEGs.txt
#
######################################### MAIN ################################

# Arguments:

Loop_genes=$1
DEGs=$2

# Correct number of arguments asseasment:

if ! [ $# -eq 2 ]; then
	echo -e "\nError. You must give 2 argument to this program\n" >&2 
	exit 1                 
fi   


# Sort:

sort ../Results/OE_and_UE_regions_loop_annotated/$Loop_genes > ../Results/OE_and_UE_regions_loop_annotated/sorted_$Loop_genes

echo "Total number of genes in potential lost loop regions:"
wc -l ../Results/OE_and_UE_regions_loop_annotated/sorted_$Loop_genes | cut -d" " -f1

# Select common lines:

comm -12 ../Results/OE_and_UE_regions_loop_annotated/sorted_$Loop_genes ../Data/$DEGs > ../Results/OE_and_UE_regions_loop_annotated/common_genes.txt

echo "Number of those genes that are in the DEG list:"
wc -l ../Results/OE_and_UE_regions_loop_annotated/common_genes.txt | cut -d" " -f1




