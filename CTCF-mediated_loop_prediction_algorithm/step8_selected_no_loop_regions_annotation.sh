#!/bin/bash

# Author: Ana Rodriguez Ronchel
#
# Date: 10-01-2021
#
###################################### DESCRIPTION ############################
#
# INPUT:
#       - Arg1: Differential expression annotated genes file obtained with the
#               DESeq2 program in the RNA-Seq analysis.
#       - Arg2: Bed file with the no loop regions with significant CES (OE and
#               UE regions bed file joined).
#       - Arg3: gene list from RNA-Seq analysis (DEGs). 
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
#     - Results/OE_and_UE_regions_no_loops: with the no loop regions with 
#                                           significant CES bed file 
#                                           generated in the step5. 
#     - Scripts: this script and the script "OE_UE_regions_annotation.py"
#
# Installed programs: Python
#
##################################### RUN EXAMPLE #############################
#
# For loops OE:
# ./step8_selected_no_loop_regions_annotation.sh No_NA_gene_exp_from_galaxy.csv No_loop_regions.bed sorted_DEGs.txt
#
######################################### MAIN ################################

# Arguments:

Expression_file=$1
Loop_regions_file=$2
DEGs=$3

# Correct number of arguments asseasment:

if ! [ $# -eq 4 ]; then
	echo -e "\nError. You must give 4 arguments to this program\n" >&2 
	exit 1                 
fi   

# Create the output directoy

mkdir ../Results/No_loop_regions_annotated

# Loop to select 52 random no loop regions and quantify the avegare number
# of genes inside them that are DEGs. 
# Note: 52 regions are selected because out of 389500 we obtained 5199 regions
# with a significant CES. Since we want to know the number of DEGs that we
# would obtain in a group of 3895 no loop regions we must analyze groups of 52 
# and calculate the avegare number of DEGs inside them

for i in {1..100}; do

    shuf -n 52 ../Results/OE_and_UE_regions_no_loop/$Loop_regions_file > ../Results/OE_and_UE_regions_no_loop/52_$Loop_regions_file

    # Run the Annotation python script 

    ./OE_UE_regions_annotation.py ../Data/$Expression_file ../Results/OE_and_UE_regions_no_loop/52_$Loop_regions_file No_loop

    sort ../Results/No_loop_regions_annotated/No_loops_genes.bed > ../Results/No_loop_regions_annotated/sorted_No_loops_genes.bed

    wc -l ../Results/No_loop_regions_annotated/sorted_No_loops_genes.bed | cut -d" " -f1 >> ../Results/No_loop_regions_annotated/n_genes_no_loops.txt

    # Select common lines (genes) and write them into a file that will be
    # analyze in the next R script:

    comm -12 ../Results/No_loop_regions_annotated/sorted_No_loops_genes.bed ../Data/$DEGs > ../Results/No_loop_regions_annotated/common_genes_no_loops_DEGs.txt

    wc -l ../Results/No_loop_regions_annotated/common_genes_no_loops_DEGs.txt | cut -d" " -f1 >> ../Results/No_loop_regions_annotated/common_genes_no_loops_DEGs_number.txt

done





