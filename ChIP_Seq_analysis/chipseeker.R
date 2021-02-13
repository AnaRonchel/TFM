# Author: Ana Rodríguez Ronchel
# Date: 09/10/2020
# Description: Functional analysis with chipseeker
# Requirements: the parent directory must have a Results file with bed 
#              files for the retained and lost peaks obtained with the
#              DiffBind_lost_vs_retained.R script
# Output: txt files with genomic information about each peak.  

# BiocManager::install("ChIPseeker")
# BiocManager::install("EnsDb.Mmusculus.v75")
# BiocManager::install("clusterProfiler")
# BiocManager::install("dplyr")

# Load libraries
library(ChIPseeker)
library(TxDb.Mmusculus.UCSC.mm10.knownGene)
library(EnsDb.Mmusculus.v75)
library(clusterProfiler)
library(AnnotationDbi)
library(org.Mm.eg.db)
library(dplyr)
library(tidyverse)

# Load data
samplefiles <- list.files("../Results", pattern= ".bed", full.names=T)
samplefiles <- as.list(samplefiles)
names(samplefiles) <- c("Lost", "Retained")

# Variable with UCSC annotations 
txdb <- TxDb.Mmusculus.UCSC.mm10.knownGene


# Annotation step 
peakAnnoList <- lapply(samplefiles, annotatePeak, TxDb=txdb, 
                       tssRegion=c(-1000, 1000), verbose=FALSE)
                        # 1kb window for the tss region considered as promoter

# Percentage of peaks associated with each genomic feature: 
peakAnnoList

# Bar diagram to represent that information
plotAnnoBar(peakAnnoList)

# Peaks distribution related with TSS
plotDistToTSS(peakAnnoList, title="CTCF binding sites distance to TSS")

# Annotate each peak
lost_annot <- data.frame(peakAnnoList[["Lost"]]@anno)
retained_annot <- data.frame(peakAnnoList[["Retained"]]@anno)

# Change the EntrezID by the gene symbol:

# Get the entrez IDs
entrez_lost <- lost_annot$geneId
entrez_retained <- retained_annot$geneId
# Return the gene symbol for the set of Entrez IDs
annotations_edb_lost <- AnnotationDbi::select(EnsDb.Mmusculus.v75,
                                         keys = entrez_lost,
                                         columns = c("GENENAME"),
                                         keytype = "ENTREZID")
annotations_edb_retained <- AnnotationDbi::select(EnsDb.Mmusculus.v75,
                                                 keys = entrez_retained,
                                                 columns = c("GENENAME"),
                                                 keytype = "ENTREZID")
# Change IDs to character type to merge
annotations_edb_lost$ENTREZID <- as.character(annotations_edb_lost$ENTREZID)
annotations_edb_retained$ENTREZID <- as.character(annotations_edb_retained$ENTREZID)


# Generate a file with the annotations for each peak
lost_annot %>% 
  left_join(annotations_edb_lost, by=c("geneId"="ENTREZID")) %>% 
  write.table(file="results/Lost_peak_annotation.txt", sep="\t", quote=F, row.names=F)

retained_annot %>% 
  left_join(annotations_edb_retained, by=c("geneId"="ENTREZID")) %>% 
  write.table(file="results/Retained_peak_annotation.txt", sep="\t", quote=F, row.names=F)
