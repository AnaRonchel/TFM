#!/bin/bash

# Author: Ana Rodriguez Ronchel
#
# Date: 18-11-2020
#
###################################### DESCRIPTION ############################
#
# Select the common elements from 2 files
#
# INPUT:
#   - Arg 1: gene list from step1 (genes with a peak in their promoter)
#   - Arg 2: gene list from step2 (DEGs) 
#   - Arg 3: "lost" or "retained"
#
# OUTPUT:
#   - 1 column file with common gene names. 
# 
###################################### REQUIREMENTS ###########################
# 
# The directory must be set to the file where this script is located. 
#
# The parent directoy must contain the next directories:  
#     - Results: both gene list
#     - Scripts: this script
#
##################################### RUN EXAMPLE #############################
#
# ./step3_number_comm_genes.sh genes_with_lost_peaks_in_promoter_regions_sorted_uniq.txt DEGs.txt lost
#
######################################### MAIN ################################

# Arguments:

genes_peaks_promoter=$1
DEGs=$2
lost_or_retained=$3

# Correct number of arguments asseasment:

if ! [ $# -eq 3 ]; then
	echo -e "\nError. You must give 3 argument to this program\n" >&2 
	exit 1                 
fi   

# Sort both files:

sort ../results/$genes_peaks_promoter > ../results/sorted_$genes_peaks_promoter

sort ../results/$DEGs > ../results/sorted_$DEGs

# Select common lines:

comm -12 ../results/sorted_$genes_peaks_promoter ../results/sorted_$DEGs > ../results/common_genes_$lost_or_retained.txt

# Quantify:

wc -l ../results/common_genes_$lost_or_retained.txt

