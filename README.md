# TFM

This repository contains the code used to perform the analysis described in the master's thesis entitled "Transcriptional and structural outcomes of genome-wide CTCF depletion in B cells". It includes 5 directories corresponding to subsections of the "Methods" section of the manuscript. To execute the scripts included in each of these directories, there must be a parent directory "data" with the files used as input and a parent directory "results" to save the new files generated. Each of the scripts includes a description of its function, the files it needs to run, the files it generates, the programs required to run it, and any considerations that need to be taken into account. The following is an overview of the directories and their scripts: 


## ChIP-Seq analysis

This directory contains the scripts used to do the binding sites study explained in section 4.2. The "data" directory must contain fastq files from the ChIP-Seq experiment and mm10 indexed genome files to start running the first script. The files needed to run the rest of the scripts (specified in the description of each one) are generated throughout the analysis. 

Scripts in this directory:

**Basic_ChIPSeq_analysis.sh** processes the reads files from the ChIP-Seq experiment and produces the peak files. It does the quality assesment with fastqc, the read mapping with bowtie2, uses samtools to convert bam to sam, sorts and filters the reads with sambamba and makes the peak-calling with macs2. 

**CTCF_chipQC.R** generates a peaks quality report with ChIPQC.

**DiffBind_lost_vs_retained.R** identifies differential binding sites and generates bed files with "lost" peaks (those only present in the control samples) and "retained" peaks (those present in both control and CTCF-deficient samples), using DiffBind.  

**Peak_size_distribution.R** makes a histogram with the size of the peaks of "lost" and "retained" groups.  

**BigWig_generation.sh** indexes the bam files with samtools and generates BigWig files with bamCompare from the suite of python tools deeptools. 

**Profile_plot_generation.sh** generates a plot of the peak signal of each sample around lost and retained peaks using computeMatrix and plotProfile functions from deeptools. 

**chipseeker.R** annotates the peaks to obtain the percentages of peaks associated with each genomic feature (promoter, 3' UTR, distal intergenic, etc). 

## CTCF motif analysis

This directory contains the scripts used to do the motif analysis explained in section 4.2.1. The "data" directoy must contain "lost" and "retained" peaks' bed files (obtained with the DiffBind_lost_vs_retained.R script) and the CTCF.motif matrix file from Homer.  

Scripts in this directory:

**Motif_analysis.sh** uses the findMotifsGenome.pl Homer program to generate several reports, among which is the knownResults.html file, containing the percentage of peaks with CTCF motif. It also annotates the peaks with the motif score.

**Motif_percentage_and_score_representation.R** generates plots of the percentages of peaks with CTCF motifs inside and the CTCF motif score distribution. 

## TADs boundaries enrichment analysis

This directory contains the scripts used to calculate the overlap between peaks and TADs boundaries shown in section 4.2.2. The "data" directoy must contain a .domain file with TAD coordinates and "lost" and "retained" peaks' bed files (obtained with the DiffBind_lost_vs_retained.R script).

Scripts in this directory:

**intersect_peaks_with_TAD_boundaries.sh** calculates the peaks overlap percentages in each 10-bp segment in a window of ±500 kb around the TAD boundary

**overlap_plot.R** plots a histogram with the percentages calculated in the previous step. 


## Analysis of CTCF binding in promoter regions

This directory contains the scripts used to quantify the number of DEGs with a lost peak in their promoter region, explained in section 4.4.1. The "data" directory must contain the peak annotation file (obtained with chipseeker.R script) and the differential expression annotated genes file obtained with the DESeq2 program in the RNA-Seq analysis. 

Scripts in this directory:

**step1_filter_genes_with_peaks_in_promoter_regions.sh** filters the peaks associated with promoter regions and generates a list with the gene names. 

**step2_select_genes_symbol_from_DE_analysis_file** extracts the DEGs names from the differential expression file obtained in the RNA-Seq analysis.

**step3_number_comm_genes.sh** selects and quantifies the genes common to the two list generated in the previous steps. 

Scheme of the analysis:

![](Scheme1.png)

## CTCF-mediated loop prediction algorithm

This directory contains the scripts used to analyse the transcriptomic regulation madiated by CTCF loops, explained in section 4.4.2. The Data directoy must contain lost and retained peaks' bed files (obtained with the DiffBind_lost_vs_retained.R script), CTCF.motif matrix file from Homer and the differential expression annotated genes file obtained with the DESeq2 program in the RNA-Seq analysis. 

Scripts in this directory:

**step1_peaks_motif_annotation.sh** uses the findMotifsGenome.pl Homer program to generate a bed file with peaks that have a motif with a score > 8.7 and annotate the strand in which the motif has been found. 

**step2_potential_loop_selection_and_sorting.sh** generates a bed file with the coordinates of the genome regions that could correspond with DNA loops that were present in the control condition but not in the CTCF-deficient condition. It uses the python script **Potential_loop_selection.py**.

**step3_random_No_loop_selection_and_sorting_x100.sh** uses the bedtools shuffle function to generate a bed file with same regions size that loop file generated in the step2 but with random location.

**step4_region_CES_annotation.sh** annotates peaks' bed files with information about the coordinated expression score (CES) of each region and the number of genes within it. It uses the python script **Region_CES_annotation.py**.

**step5_loop_and_no_loop_features.R** produces plots related with different characteristics of the loop and no loop regions generated in the previous steps (region size, number of genes, CES) and selects regions with a significant CES (Differentially Expressed Regions, DERs).  

**step6_loop_DERs_annotation.sh** annotates the DERs from the loop group selected in step 5 with the genes included in each of the regions and list with the gene names. It uses the python script **DERs_annotation.py**.

**step7_DEGs_in_loop_DERs.sh** selects and quantifies the genes common to the DEGs list and the gene list generated in step 6 (genes inside loop DERs).

**step8_no_loop_DERs_annotation_and_DEGs_quantification.sh** annotates the DERs from the no-loop group selected in the step5 with the genes included in each of the regions and quantify how many of those genes are DEGs. It uses the python script **DERs_annotation.py**. The output is a file with the number of DEGs included in 100 random groups of no-loop DERs.

**step9_DEGs_in_no_loop_DERs.R** calculates the average number of DEGs included in the 100 groups of no loop DERs annotated in the step8.

Scheme of first 4 steps of the analysis:

![](Scheme2.png)

More details about the analysis can be found in the description included in each script.

### Softwares needed:

**fastqc**: http://www.bioinformatics.babraham.ac.uk/projects/fastqc/

**bowtie2**: Langmead, B. & Salzberg, S. L. Fast gapped-read alignment with Bowtie 2. Nature Methods 9, 357–359 (2012).

**samtools**: Li, H. et al. The Sequence Alignment/Map format and SAMtools. Bioinformatics 25, 2078– 2079 (2009).

**sambamba**: Tarasov, A., Vilella, A. J., Cuppen, E., Nijman, I. J. & Prins, P. Sambamba: fast processing of NGS alignment formats. Bioinformatics 31, 2032–2034 (2015).

**macs2**: Zhang, Y. et al. Model-based analysis of ChIP-Seq (MACS). Genome Biology 9, R137 (2008).

**ChIPQC**: Carroll, T. S., Liang, Z., Salama, R., Stark, R. & de Santiago, I. Impact of artifact removalon ChIP quality metrics in ChIP-seq and ChIP-exo data.Frontiers in Genetics5(2014).

**Diffbind**: Ross-Innes, C. S. et al. Differential oestrogen receptor binding is associated with clinical outcome in breast cancer. Nature 481, 389–393 (2012).

**R**: R Core Team. R: A Language and Environment for Statistical Computing https://www.r-project.org/

**deeptools**: Ramírez, F. et al. deepTools2: a next generation web server for deep-sequencing data anal- ysis. Nucleic acids research 44, W160–W165 (2016).

**ChIPseeker**: Yu, G., Wang, L. G. & He, Q. Y. ChIP seeker: An R/Bioconductor package for ChIP peak annotation, comparison and visualization. Bioinformatics 31, 2382–2383 (2015).

**Homer**: Heinz, S. et al. Simple Combinations of Lineage-Determining Transcription Factors Prime cis-Regulatory Elements Required for Macrophage and B Cell Identities. Molecular Cell 38, 576–589 (2010).

**bedtools**: Quinlan, A. R. & Hall, I. M. BEDTools: a flexible suite of utilities for comparing genomic features. Bioinformatics 26, 841–842 (2010).

**python**: https://www.python.org/




