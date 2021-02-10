#!/bin/bash
#
# Author: Ana Rodriguez Ronchel
#
# Date: 08-10-2020
#
###################################### DESCRIPTION ############################
#
# This script processes fastq files to perform quality analysis and peak calling.
# It produces files needed for posterior analysis steps such as differential
# binding analisis, BigWig generation, etc. 
#
# OUTPUT:
#   - Fastqc report in the Data file
#   - bam file sorted and filtered in the Results file
#   - Index for each bam file in the Results file
#   - narrowPeaks files and other reports from MACS2 in the Results file 
# 
###################################### REQUIREMENTS ###########################
# 
# The directory must be set to the file where this script is located. 
#
# The parent directoy must contain the next directories: 
#     - Data: mm10 genome indexed, fastq files
#     - Results: empty
#     - Scripts: this script
#
# Installed programs: fastqc, bowtie2, samtools, sambamba-0.6.8, macs2
#
##################################### RUN EXAMPLE #############################
#
# ./Basic_ChIPSeq_analysis.sh
#
######################################### MAIN ################################

for file in ../Data/*.fastq.gz
do

# Quality assesment
	fastqc $1

# Mapping
	bowtie2 -x ../Data/mm10 -U ../Data/$1.fastq.gz -S ../Results/$1.sam --no-unal -p 6

# Bam to Sam format
	samtools view -h -S -b -o ../Results/$1.bam ../Results/$1.sam

# Sorting
	sambamba-0.6.8 sort -t 6 -o ../Results/$1.sorted.bam ../Results/$1.bam

# Filtering
	sambamba-0.6.8 view -h -t 6 -f bam -F "[XS] == null and not unmapped and not duplicate" ../Results/$1.sorted.bam > ../Results/$1.sorted.filtered.bam

# Peak-calling
	macs2 callpeak -t $1.sorted.filtered.bam -c $2.sorted.filtered.bam -f BAM -g 2.3e+9 -n $1 --outdir . 2> $1_MACS2.log

# Removing intermediate files
	rm ../Results/$1.sam
	rm ../Results/$1.bam
	rm ../Results/$1.sorted.bam

done

