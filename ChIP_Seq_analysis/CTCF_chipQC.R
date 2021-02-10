# Author: Ana Rodríguez Ronchel
# Date: 08/10/2020
# Description: Quality assessment of ChIP data with chIPQC
# Requirements: the parent directory must have a meta file with a samplesheet 
#              with the information about the location of the sorted_filtered.sam
#              files, the narowpeaks files and indications about groups and 
#              replicates.
# Output: A file called ChIPQCreport_CTCF_naive with a quality report.  

#Packages:

# library(BiocManager)
# install("ChIPQC") 
library(ChIPQC)

# Load of the samplesheet
samples <- read.csv('../meta/samplesheet_CTCF_naive.csv')
View(samples)

register(SerialParam())
      
## Create ChIPQC object
chipObj <- ChIPQC(samples, annotation="mm10")

## Create ChIPQC report
ChIPQCreport(chipObj, reportName="ChIP QC report: CTCF B-cell naive", reportFolder="ChIPQCreport_CTCF_naive")