#!/usr/bin/env python

# Author: Ana Rodriguez Ronchel
# Date: 18-11-2020
# Description: This script annotates a BED file with information about the
#              coordinated expression score (CES) of each region and the number
#              of genes within it. CES is calculated as the mean ponderated 
#              logFC of the genes inside the regions (lines 67 and 71 of this
#              script).
#
# Input:
#       - Arg1: Differential expression annotated genes file obtained with the
#               DESeq2 program in the RNA-Seq analysis. LogFC in column 3, 
#               p-values in column 6 and chr, start and end positions in 
#               columns 8-10.
#       - Arg2: 3 column bed file with the loop or no-loop regions (chr, start, end)
#       - Arg3: YES if you want to annotate the loop file or NO if you want
#               to annotate the no loop file.
# Output:
#       - 5 column bed file with the loop or no-loop regions coordinates, the
#         Coordinated Expression Score (CES) of each region and the number of 
#         genes within them (chr, start, end, CES, n_genes)
#
# Execution example:
# For loops
# ./Region_CES_annotation.py ../Data/No_NA_gene_exp_from_galaxy.csv ../Results/Potential_loop_file_100kb/Potential_loops.bed YES
# For no loops
# ./Region_CES_annotation.py ../Data/No_NA_gene_exp_from_galaxy.csv ../Results/No_loop_file_random_100kb/No_loops.bed NO

################################# MAIN #########################################

# Argument import and variable asignation:
import sys
import math

Genes_exp = sys.argv[1]
Potential_loops = sys.argv[2]
loops_or_not = sys.argv[3]

loops_file = open(Potential_loops, 'r')

if loops_or_not == "YES":
    output_file = open("../Results/Potential_loop_file_annotated/Potential_loops_annotated.bed", 'w')
elif loops_or_not == "NO":
    output_file = open("../Results/No_loop_file_annotated/No_loops_annotated.bed", 'w')
else:
    print("You should indicate as Arg3 if the Arg2 is a loop file or not")

for loop in loops_file:
    Loop=loop.strip().split()
    Loop_chr=Loop[0]
    Loop_start=int(Loop[1])
    Loop_end=int(Loop[2])
    sum_log_FC_ponderated=0
    n_genes=0
    with open(Genes_exp, 'r') as genes_file:
        for gene in genes_file:
            Gene=gene.strip().split()
            Gene_chr=Gene[7]
            Gene_start=int(Gene[8])
            Gene_end=int(Gene[9])
            log_FC=float(Gene[2])
            p_value=float(Gene[5])
            if Loop_chr == Gene_chr:
                if Loop_start<Gene_start and Loop_end>Gene_end: #if gene inside loop
                    n_genes+=1
                    sum_log_FC_ponderated+=log_FC*-math.log10(p_value) #sum ponderated logFC
    if n_genes==0:
        mean_log_FC_ponderated=0
    else:
        mean_log_FC_ponderated=sum_log_FC_ponderated/n_genes #CES calculation
    output_file.write(loop.strip())
    output_file.write("\t")
    output_file.write(str(mean_log_FC_ponderated))
    output_file.write("\t")
    output_file.write(str(n_genes))
    output_file.write("\n")

loops_file.close()
output_file.close()
