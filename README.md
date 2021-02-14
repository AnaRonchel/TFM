# TFM

This repository contains the code used to perform the analysis described in the master's thesis entitled "Transcriptional and structural outcomes of genome-wide CTCF depletion in B cells". It includes 5 directories that correspond to subsections of the methods section of the TFM memory. To execute the scripts included in each of these directories, there must be a parent directory "data" with the files used as input and a parent directory "results" to save the new files generated. Each of the scripts includes a description of its function, the files it needs to run, the files it generates, the programs required to run it, and any considerations that need to be taken into account. The following is an overview of the directories and their scripts: 


## ChIP-Seq analysis

This directory contains the scripts used to do the binding sites study explained in the section 4.2 of the master thesis. The Data directoy must contain fastq files from ChIP-Seq experiment and mm10 indexed genome files in order to start running the first script. The files needed to run the rest of the scripts (specified in the description of each one) are generated throughout the analysis. 

Scripts in this directory:

**Basic_ChIPSeq_analysis.sh** processes the reads files from ChIP-Seq experiment and obtains the peak files. It does the quality assesment with fastqc, the read mapping with bowtie2, uses samtools to convert bam to sam, sort and filters the reads with sambamba and makes the peak-calling with macs2. 

**CTCF_chipQC.R** generates a quality report about the peaks with ChIPQC.

**DiffBind_lost_vs_retained.R** identifies differential binding sites and generates bed files with "lost" peaks (those only present in the control samples) and "retained" peaks (those present in both control and CTCF-deficient samples), using DiffBind.  

**Peak_size_distribution.R** makes a histogram with the size of the peaks of lost and retained groups.  

**BigWig_generation.sh** indexes the bam files with samtools and generates BigWig files with bamCompare from the suite of python tools deeptools. 

**Profile_plot_generation.sh** generates a plot of the peak signal of each sample around lost and retained peaks using computeMatrix and plotProfile functions from deeptools. 

**chipseeker.R** annotates the peaks to obtain the percentages of peaks associated with each genomic feature (promoter, 3' UTR, distal intergenic, etc). 

## CTCF motif analysis

This directory contains the scripts used to do the motif analysis explained in the section 4.2.1 of the master thesis. The Data directoy must contain lost and retained peaks bed files (obtained with the DiffBind_lost_vs_retained.R script) and the CTCF.motif matrix file from Homer.  

Scripts in this directory:

**Motif_analysis.sh** uses the findMotifsGenome.pl homer program to generate several reports, among which is the knownResults.html file, from which we get the percentage of peaks with CTCF motif. It also annotates the peaks with the motif score.

**Motif_percentage_and_score_representation.R** generates the plots of the percentages of peaks with CTCF motifs inside and of the CTCF motif score distribution. 

## TADs boundaries enrichment analysis

This directory contains the scripts used to calculated the overlap between peaks and TADs boundaries shown in the section 4.2.2 of the master thesis. The Data directoy must contain a .domain file with TAD coordinates and lost and retained peaks bed files (obtained with the DiffBind_lost_vs_retained.R script).

Scripts in this directory:

**intersect_peaks_with_TAD_boundaries.sh** calculates the peaks overlap percentages in each 10bp segment in a window of ±500 kb around the TAD boundary

**overlap_plot.R** makes a histogram with the percentages calculated in the previous step. 


## Analysis of CTCF binding in promoter regions

This directory contains the scripts used to quantify the number of DEGs with a lost peak in their promoter region, explained in the section 4.4.1 of the master thesis. The Data directoy must contain the peak annotation file (obtained with chipseeker.R script) and the differential expression annotated genes file obtained with the DESeq2 program in the RNA-Seq analysis. 

Scripts in this directory:

**step1_filter_genes_with_peaks_in_promoter_regions.sh** filters the peaks associated with promoter regions and generates a list with the gene names. 

**step2_select_genes_symbol_from_DE_analysis_file** extract the DEGs names from the differential expression file obtained in the RNA-Seq analysis

**step3_number_comm_genes.sh** select and quantify the genes common to the two list generated in the previous steps. 

Scheme of the analysis:

![](Scheme1.png)

## CTCF-mediated loop prediction algorithm

This directory contains the scripts used to analyse the transcriptomic regulation madiated by CTCF loops, explained in the section 4.4.2 of the master thesis. The Data directoy must contain lost and retained peaks bed files (obtained with the DiffBind_lost_vs_retained.R script), CTCF.motif matrix file from Homer, 

Scripts in this directory:

**step1_peaks_motif_annotation.sh** uses the findMotifsGenome.pl homer program to generate a bed file with peaks that have a motif with a score > 8.7 and annotate the strand in which the motif has been found. 

**step2_potential_loop_selection_and_sorting.sh** generates a bed file with the coordinates of the genome regions that could correspond with DNA loops that were present in the control condition but not in the CTCF-deficient condition. It make use of the python script **Potential_loop_selection.py**.

**step3_random_No_loop_selection_and_sorting_x100.sh** uses the bedtools shuffle function to generate a bed file with same regions size that loop file generated in the step2 but with random location.

**step4_region_CES_annotation.sh** 


Scheme of first 4 steps of the analysis:

![](Scheme2.png)


More details about the scripts can be found in the description they contain.

The following softwares were used:

fastqc
bowtie2
samtools
sambamba
macs2
ChIPQC
Diffbind
R
deeptools
Homer
bedtools





