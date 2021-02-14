#!/bin/bash

# Author: Ana Rodriguez Ronchel
#
# Date: 10-01-2021
#
###################################### DESCRIPTION ############################
#
# This script annotates a BED file with the genes included in each of the 
# DERs selected in step 5, to perform posterior analysis. 
#
# INPUT:
#       - Arg1: Differential expression annotated genes file obtained with the
#               DESeq2 program in the RNA-Seq analysis.
#       - Arg2: Bed file with the loop regions with significant CES (both 
#               overexpressed or underexpressed regions)
#       - Arg3: OE for overexpressed regions or UE for underexpressed regions  
#
# OUTPUT:
#       - 6 column bed file with the following information per region:
#         chr, start, end, CES, n_genes, list_genes
# 
###################################### REQUIREMENTS ###########################
# 
# The directory must be set to the file where this script is located. 
#
# The parent directoy must contain the next directories: 
#     - Data: with the expression file 
#     - Results/OE_and_UE_regions: with the loop regions bed files generated
#                                  in the previous step. 
#     - Scripts: this script and the script "DERs_annotation.py"
#
# Installed programs: Python
#
##################################### RUN EXAMPLE #############################
#
# For loops OE:
# ./step6_loop_DERs_annotation.sh No_NA_gene_exp_from_galaxy.csv Loop_OE_regions.bed OE
# 
# For loops UE:
# ./step6_loop_DERs_annotation.sh No_NA_gene_exp_from_galaxy.csv Loop_UE_regions.bed UE
#
######################################### MAIN ################################

# Arguments:

Expression_file=$1
Loop_regions_file=$2
OE_or_UE=$3

# Correct number of arguments asseasment:

if ! [ $# -eq 3 ]; then
	echo -e "\nError. You must give 3 arguments to this program\n" >&2 
	exit 1                 
fi   

# Create the output directoy

mkdir ../Results/OE_and_UE_regions_loop_annotated

# Run the python script

./DERs_annotation.py ../Data/$Expression_file ../Results/OE_and_UE_regions/$Loop_regions_file $OE_or_UE








