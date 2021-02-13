# TFM

This repository contains the code used to perform the analysis described in the master's thesis entitled "Transcriptional and structural outcomes of genome-wide CTCF depletion in B cells". It includes 5 directories that correspond to subsections of the methods section of the TFM memory. To execute the scripts included in each of these directories, there must be a parent directory "data" with the files used as input and a parent directory "results" to save the new files generated. Each of the scripts includes a description of its function, the files it needs to run, the files it generates, the programs required to run it, and any considerations that need to be taken into account. The following is an overview of the directories and their scripts: 


## ChIP-Seq analysis

Data directoy with fastq files, mm10 genome indexed, 

**Basic_ChIPSeq_analysis.sh** processes the reads from ChIP-Seq experiment and obtained the peak files. It does the quality assesment with Fastqc, the read mappingg with bowtie2 and the peak-calling with macs2. 

![](Scheme1.png)







![](Scheme2.png)

