#!/bin/bash

# Author: Ana Rodriguez Ronchel
#
# Date: 12-01-2021
#
###################################### DESCRIPTION ############################
#
# Filter a file to show only the 15th column (gene symbol) of lines with 
# "promoter" in their 6th column
#
# INPUT:
#   - Arg 1: peaks annotation txt files obtained in the ChIP-Seq analysis with 
#            the chipseeker.R script. 
#   - Arg 2: "lost" or "retained" to indicate the type of peaks. 
#
# OUTPUT:
#   - 1 column file with gene symbol of genes with a peak in their promoter. 
# 
###################################### REQUIREMENTS ###########################
# 
# The directory must be set to the file where this script is located. 
#
# The parent directoy must contain the next directories: 
#     - Data: peaks annotated txt file 
#     - Results: empty
#     - Scripts: this script
#
##################################### RUN EXAMPLE #############################
#
# ./step1_filter_genes_with_peaks_in_promoter_regions.sh ../data/Lost_peak_annotation.txt lost
#
######################################### MAIN ################################

# Arguments:

Peaks_annotated_file=$1
lost_or_retained=$2

# Correct number of arguments asseasment:

if ! [ $# -eq 2 ]; then
	echo -e "\nError. You must give 2 argument to this program\n" >&2 
	exit 1                 
fi   


# Filter the file:

awk -F'\t' -v OFS='\t' '{ if ($6=="Promoter") { print $15 } }' $Peaks_annotated_file > ../results/genes_with_"$lost_or_retained"_peaks_in_promoter_regions.txt

# Remove duplicated lines:

sort ../results/genes_with_"$lost_or_retained"_peaks_in_promoter_regions.txt > ../results/genes_with_"$lost_or_retained"_peaks_in_promoter_regions_sorted.txt

uniq ../results/genes_with_"$lost_or_retained"_peaks_in_promoter_regions_sorted.txt > ../results/genes_with_"$lost_or_retained"_peaks_in_promoter_regions_sorted_uniq.txt

# Remove temporal files:

rm ../results/genes_with_"$lost_or_retained"_peaks_in_promoter_regions.txt
rm ../results/genes_with_"$lost_or_retained"_peaks_in_promoter_regions_sorted.txt

