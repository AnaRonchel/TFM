# Author: Ana Rodríguez Ronchel
# Date 08/10/2020
# Description: Differential binding analysis with DiffBind.
# Requirements: the parent directory must have a meta file with a samplesheet 
#              with the information about the location of the sorted_filtered.sam
#              files, the narowpeaks files and indications about groups and
#              replicates. 
# Output: 2 bed files with peaks from flox (CTCF-deficient) groups only and
#         peaks shared in both conditions. Informative plots are also
#         generated along the script.

# Packages:

#BiocManager::install("DiffBind")
library(DiffBind)
#BiocManager::install("tidyverse")
library(tidyverse)

# MAIN (DiffBind_vignette: 6.3 A complete occupancy analysis:
       # identifying sites unique to a sample group)

# 1. Reading Peaksets
dbObj <- dba(sampleSheet='../meta/samplesheet_CTCF_naive.csv')
dbObj # From the 54747 total peaks, the consensus group is only 
      # form by 37002 (peaks present in at least 2 of the samples)

olap.rate <- dba.overlap(dbObj, mode=DBA_OLAP_RATE)
olap.rate

# Plot showing the information above
plot(olap.rate,type='b',ylab='# peaks', xlab='Overlap at least this many peaksets')

# Overlap between control replicates
dba.overlap(dbObj,dbObj$masks$Control,mode=DBA_OLAP_RATE)

# Overlap between flox replicates
dba.overlap(dbObj,dbObj$masks$Flox,mode=DBA_OLAP_RATE)


# Next, we want to know how many of the peaks are shared between both conditions
# and how many are specific for only one condition. We established a minOverlap
# of 0.66 which means that at least 2 out of 3 replicates must have the peak
# to include it in the analysis. That increase the confidence of the study. 
dbObj <- dba.peakset(dbObj, consensus=DBA_CONDITION, minOverlap=0.66)

# Overlap between samples of both consitions
dba.plotVenn(dbObj,dbObj$masks$Consensus)

# Select peaks
dbObj.OL <- dba.overlap(dbObj, dbObj$masks$Consensus)
dbObj.OL$onlyA # Only in Control
dbObj.OL$inAll # In Control y Flox

# Generation of data frames:
out_lost <- as.data.frame(dbObj.OL$onlyA)
out_retained <- as.data.frame(dbObj.OL$inAll)

# Selections of columns 
peaks_lost <- out_lost %>% 
  select(seqnames, start, end)

peaks_retained <- out_retained %>% 
  select(seqnames, start, end)

# Write to bed files
write.table(peaks_lost, file="../Results/Lost.bed", sep="\t", quote=F, row.names=F, col.names=F)
write.table(peaks_retained, file="../Results/Retained.bed", sep="\t", quote=F, row.names=F, col.names=F)

