#!/bin/bash
#
# Author: Ana Rodriguez Ronchel
#
# Date: 24-10-2020
#
###################################### DESCRIPTION ############################
#
# This script allows to study the presence of different motifs within the
# peak sequences and annotate the score of CTCF motifs in those peaks. Only 
# CTCF motifs with a score > 8.7 are considered by homer.
#
# OUTPUT:
#   - Homer report files (percentage of peaks with CTCF motif can be found in 
#     the knownResults.html file). 
#   - txt files with CTCF motif score of each peak.
# 
###################################### REQUIREMENTS ###########################
# 
# The directory must be set to the file where this script is located. 
#
# The parent directoy must contain the next directories: 
#     - Data: bed files for lost and retained peaks obtained in the ChIP-Seq
#                analysis with the DiffBind_lost_vs_retained.R script. 
#                CTCF.motif matrix file
#     - Scripts: this script
#     - Results: empty
#
# Installed programs: homer with the mm10 genome installed.
#
##################################### RUN EXAMPLE #############################
#
# ./Motif_analysis.sh
#
######################################### MAIN ################################

# To generate the homer report of known and new motifs.
 
findMotifsGenome.pl ../Data/Lost.bed mm10 ../results/Lost_homer_results -size given -mask

findMotifsGenome.pl ../Data/Retained.bed mm10 ../results/Retained_homer_results -size given -mask


# To annotate the motif score of each peak.  

findMotifsGenome.pl ../Data/Lost.bed mm10 ../results/Lost_homer_annotation -find ../data/CTCF.motif -size given -mask > ../results/Lost_homer_annotation/Lost_annotated.txt

findMotifsGenome.pl ../Data/Retained.bed mm10 ../results/Retained_homer_annotation -find ../data/CTCF.motif -size given -mask > ../results/Retained_homer_annotation/Retained_annotated.txt


