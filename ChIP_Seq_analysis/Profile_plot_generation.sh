#!/bin/bash
#
# Author: Ana Rodriguez Ronchel
#
# Date: 08-10-2020
#
###################################### DESCRIPTION ############################
#
# This script allows to generate profile plots to asses the enrichment around 
# lost and retained peaks for the control (C) and CTCF-deficient samples (FL) 
# (3 replicates in each plot). 
#
# OUTPUT:
#   - pdf with plots showing the peak enrichment around lost and retained peaks. 
# 
###################################### REQUIREMENTS ###########################
# 
# The directory must be set to the file where this script is located. 
#
# The parent directoy must contain the next directories: 
#     - Results: .bw files for the 6 samples (generated with the script 
#                BigWig_generation.sh) and .bed files for retained and lost
#                peaks (generated with the script DiffBind_lost_vs_retained.R). 
#     - Scripts: this script
#
# Installed programs: deeptools
#
##################################### RUN EXAMPLE #############################
#
# ./Profile_plot_generation.sh
#
######################################### MAIN ################################

# Anaconda activation (deeptools is a pyhton tool)
source ~/anaconda3/bin/activate root


# Enrichment around retained peaks
computeMatrix reference-point \
       --referencePoint center \
       --sortRegions descend \
       --sortUsingSamples 1 \
       --outFileName ../Results/Retained_CvsFL.gz \
       --missingDataAsZero \
       -b 1000 -a 1000 \
       -R ../Results/Retained_peaks.bed \
       -S ../Results/*.bw
 
plotProfile -m ../Results/Retained_CvsFL.gz  \
              -out ../Results/profile_Retained_CvsFL.pdf \
              --outFileNameData ../Results/profile_Retained_CvsFL.tab \
              --dpi 300 \
              --colors red red red green green green \
              --yMax 2\
              --perGroup

# Enrichment around lost peaks
computeMatrix reference-point \
       --referencePoint center \
       --sortRegions descend \
       --sortUsingSamples 1 \
       --outFileName ../Results/Lost_CvsFL.gz \
       --missingDataAsZero \
       -b 1000 -a 1000 \
       -R ../Results/Lost_peaks.bed \
       -S ../Results/*.bw
 
plotProfile -m ../Results/Lost_CvsFL.gz  \
              -out ../Results/profile_LOST_CvsFL.pdf \
              --outFileNameData ../Results/profile_LOST_CvsFL.tab \
              --dpi 300 \
              --colors red red red green green green \
              --yMax 2\






