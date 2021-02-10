#!/bin/bash
#
# Author: Ana Rodriguez Ronchel
#
# Date: 08-10-2020
#
###################################### DESCRIPTION ############################
#
# This script allows to generate BigWig files needed for the visualization of
# peak profile with IGV software. 
#
# OUTPUT:
#   - bai index files. 
#   - BigWig files
# 
###################################### REQUIREMENTS ###########################
# 
# The directory must be set to the file where this script is located. 
#
# The parent directoy must contain the next directories: 
#     - Results: sorted.filtered.bam files obtained with the
#                Basic_ChIPSeq_analysis.sh script. The input 
#                sample must be called "input".
#     - Scripts: this script
#     - Log: empty file to save log files 
#
# Installed programs: samtools, bamCompare
#
##################################### RUN EXAMPLE #############################
#
# ./BigWig_generation.sh
#
######################################### MAIN ################################


# Generation of index file (bai format)
for file in ../Results/*.sorted.filtered.bam
do
	samtools index $file
done

# Anaconda activation (bam compare is a pyhton tool)
source ~/anaconda3/bin/activate root

# BigWig generation
for nombre in C1 C2 C3 FL1 FL2 FL3
do
	bamCompare -b1 ../Results/$nombre.sorted.filtered.bam \
	-b2  ../Results/input.sorted.filtered.bam \
	-o ../Results/$nombre.bw \
	--binSize 20 \
	--scaleFactorsMethod None \
	--normalizeUsing BPM \
	--smoothLength 60 \
	--extendReads 150 \
	--centerReads \
	-p 6 2> ../Log/$nombre.log
done 

