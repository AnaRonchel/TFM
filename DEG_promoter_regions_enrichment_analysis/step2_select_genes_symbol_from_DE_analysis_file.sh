#!/bin/bash

# Author: Ana Rodriguez Ronchel
#
# Date: 12-01-2021
#
###################################### DESCRIPTION ############################
#
# Remove the header and extract the 13th column of a file.
#
# INPUT:
#   - Arg 1: Differential expression annotated genes file obtained with the
#            DESeq2 program in the RNA-Seq analysis. 
#
# OUTPUT:
#   - 1 column file with gene names. 
# 
###################################### REQUIREMENTS ###########################
# 
# The directory must be set to the file where this script is located. 
#
# The parent directoy must contain the next directories: 
#     - Data: DEGs annotated file in .tabular format
#     - Results
#     - Scripts: this script
#
##################################### RUN EXAMPLE #############################
#
# ./step2_select_genes_symbol_from_DE_analysis_file.sh ../data/DEGs_annotated.tabular
#
######################################### MAIN ################################

# Arguments:

DEGs_file=$1

# Correct number of arguments asseasment:

if ! [ $# -eq 1 ]; then
	echo -e "\nError. You must give 1 argument to this program\n" >&2 
	exit 1                 
fi   


# Remove header and select the genes column:

tail -n +2 $DEGs_file | cut -f 13  > ../results/DEGs.txt


