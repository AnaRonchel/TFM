#!/usr/bin/env python

# Author: Ana Rodriguez Ronchel
# Date: 10-01-2021
# Description: This script annotates a BED file with the genes included in
#              each of the regions with a significant CES (Differentially
#              Expressed Regions, DERs).
#
# Input:
#       - Arg1: Differential expression annotated genes file obtained with the
#               DESeq2 program in the RNA-Seq analysis. chr, start and end 
#               positions in columns 8-10 and the name of the gene in column 13
#       - Arg2: bed file obtained with step4_region_CES_annotation.sh script
#       - Arg3: OE for overexpressed regions or UE for underexpressed regions  
#
# Output:
#       - 6 column bed file with the following information per region:
#         chr, start, end, CES, n_genes, list_genes
#
# Execution example:
#
# ./DERs_annotation.py ../Data/gene_exp_from_galaxy.csv ../Results/OE_and_UE_regions/Loop_OE_regions.bed OE
# ./DERs_annotation.py ../Data/gene_exp_from_galaxy.csv ../Results/OE_and_UE_regions/Loop_UE_regions.bed UE
#
################################# MAIN #########################################

# Argument import and variable asignation:
import sys
import math

Genes_exp = sys.argv[1]
OE_or_UE_regions = sys.argv[2]
OE_or_UE = sys.argv[3]

loops_file = open(OE_or_UE_regions, 'r')

# Generation of output files
if OE_or_UE == "OE":
    output_file = open("../Results/OE_and_UE_regions_loop_annotated/OE_loops_annotated.bed", 'w')
    genes_list_file = open("../Results/OE_and_UE_regions_loop_annotated/OE_loops_genes.bed", 'w')
elif OE_or_UE == "UE":
    output_file = open("../Results/OE_and_UE_regions_loop_annotated/UE_loops_annotated.bed", 'w')
    genes_list_file = open("../Results/OE_and_UE_regions_loop_annotated/UE_loops_genes.bed", 'w')
elif OE_or_UE== "No_loop":
    output_file = open("../Results/No_loop_regions_annotated/No_loops_annotated.bed", 'w')
    genes_list_file = open("../Results/No_loop_regions_annotated/No_loops_genes.bed", 'w')
else:
    print("You should give 3 arguments")


Genes_list=[] # List with the genes included in the group of regions
for loop in loops_file:
    Loop=loop.strip().split()
    Loop_chr=Loop[0]
    Loop_start=int(Loop[1])
    Loop_end=int(Loop[2])
    Genes=[] # List with the genes included in each individual region
    with open(Genes_exp, 'r') as genes_file:
        for gene in genes_file:
            Gene=gene.strip().split()
            Gene_chr=Gene[7]
            Gene_start=int(Gene[8])
            Gene_end=int(Gene[9])
            if Loop_chr == Gene_chr:
                if Loop_start<Gene_start and Loop_end>Gene_end:
                    Genes.append(Gene[12])
                    if Gene[12] not in Genes_list:
                        Genes_list.append(Gene[12])

    output_file.write(loop.strip())
    output_file.write("\t")
    output_file.write(str(Genes))
    output_file.write("\n")

# Write a file with all gene names. 
for gene in Genes_list:
    genes_list_file.write(gene)
    genes_list_file.write("\n")

loops_file.close()
output_file.close()
genes_list_file.close()
