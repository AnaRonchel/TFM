# DATE: 08/11/2020
#
# AUTHOR: Ana Rodriguez Ronchel
#
# DESCRIPTION: 
# This script generates plots related with differents characteristic of
# the loop and no loop regions generated in the previous steps:
#     - Size of the regions
#     - Number of genes per region.
#     - CES distribution
# It also stablishes a CES threshold based on p-value in a first step and
# based on the adj. p-value later.
#
# REQUIREMENTS:
# The working directory must be set in the file where this script is.
# There must be a Result file with the files generated in the previous steps
# of this algorithm. 
#
# INSTALL PACKAGES

#install.packages("tidyverse")
library("ggplot2")
library(dplyr)
library(tidyr)
#install.packages("ggpubr") #To calculate the p-value of the differences between two groups
library(ggpubr)
library(ggforce)
library(lattice)
library(scales) # For percent_format()
library(RColorBrewer) # For colours of th pie chart

# LOAD DATA
df_potential_loops_annotated <- read.csv("../Results/Potential_loop_file_annotated/Potential_loops_annotated.bed", sep="\t", header = FALSE)
names(df_potential_loops_annotated) <- c("Chr","Start","End","CES","n_genes")
df_no_loops_annotated <- read.csv("../Results/No_loop_file_annotated/No_loops_annotated.bed", sep="\t", header = FALSE)
names(df_no_loops_annotated) <- c("Chr","Start","End","CES","n_genes")

# Now, combine your two dataframes into one.  

# First make a new column in each dataframe that will be 
# a variable to identify where they came from later.
df_potential_loops_annotated$Group <- 'Loops'
df_no_loops_annotated$Group <- 'No_loops'

# and combine into your new data frame vegLengths
df_loops_and_no_loops_annotated <- rbind(df_potential_loops_annotated, df_no_loops_annotated)

# REGION SIZE.

t.test(End-Start ~ Group, data = df_loops_and_no_loops_annotated)

# Histogram
ggplot(df_loops_and_no_loops_annotated, aes(End-Start, fill=Group, colour=Group)) +
  geom_histogram(aes(y=2*(..density..)/sum(..density..)), breaks=seq(0,100000,1000), alpha=0.5, 
                 position="identity", lwd=0.2) +
  scale_y_continuous(labels=percent_format()) +
  ggtitle("Region size distribution") + 
  xlab("Region size (bp)") + 
  ylab("Pertentage")


# NUMBER OF GENES PER REGION

t.test(n_genes ~ Group, data = df_loops_and_no_loops_annotated)
compare_means(n_genes ~ Group, data = df_loops_and_no_loops_annotated)

# Boxplot
n_genes_boxplot <- ggplot(df_loops_and_no_loops_annotated, aes(x=Group, y=n_genes, fill=Group)) + 
  geom_boxplot(alpha=0.3) +
  theme(legend.position="none")

n_genes_boxplot + 
  ggtitle("Number of genes per region boxplot") + 
  xlab("Group") + 
  ylab("Genes per region") + 
  labs(fill = "Group") +
  stat_compare_means(method = "wilcox.test", label = "p.signif",  size= 8, label.x = 1.4, label.y=10)

# Histogram
ggplot(df_loops_and_no_loops_annotated, aes(n_genes, fill=Group, colour=Group)) +
  geom_histogram(aes(y=2*(..density..)/sum(..density..)), breaks=seq(-1,10,1), alpha=0.5, 
                 position="identity", lwd=0.2) +
  scale_y_continuous(labels=percent_format()) +
  ggtitle("Number of genes per region distribution") + 
  xlab("Number of genes per region") + 
  ylab("Pertentage") 


# CES

t.test(CES ~ Group, data = df_loops_and_no_loops_annotated) #veo que las medias son muy similares
compare_means(CES ~ Group, data = df_loops_and_no_loops_annotated)

# Boxplot
measure_boxplot <- ggplot(df_loops_and_no_loops_annotated, aes(x=Group, y=CES, fill=Group)) + 
  geom_boxplot(alpha=0.3) +
  theme(legend.position="none")

measure_boxplot + 
  ggtitle("Mean(logFC*-log10(p-value)) boxplot") + 
  xlab("Group") + 
  ylab("Mean(logFC*-log10(p-value)) per region") + 
  labs(fill = "Group") +
  stat_compare_means(method = "wilcox.test", label = "p.signif",  size= 8, label.x = 1.4, label.y=100)

# Histogram
ggplot(df_loops_and_no_loops_annotated, aes(CES, fill=Group, colour=Group)) +
  geom_histogram(aes(y=2*(..density..)/sum(..density..)), breaks=seq(-0.4,0.4,0.05), alpha=0.5, 
                 position="identity", lwd=0.2) +
  scale_y_continuous(labels=percent_format()) +
  ggtitle("Mean(logFC*-log10(p-value)) distribution") + 
  xlab("Mean(logFC*-log10(p-value)) per region") + 
  ylab("Pertentage")
  

# THRESHOLD ESTABLISHMENT:

# Calculation of a threshold for p-value<0.05

# pvalue is calculated as the percentage of no-loop regions over 
# the CES threshold. The loop continues increasing the x (threshold) 
# until the pvalue (percentage of regions over the threshold) is 
# 0.05 or lower. 

pvalue <- 1
x <- 0.00
while (pvalue > 0.05) {
  x = x+0.0001
  no_loop_OE<-length(which(df_no_loops_annotated$CES > x ))/nrow(df_no_loops_annotated)
  no_loop_UE<-length(which(df_no_loops_annotated$CES < -x ))/nrow(df_no_loops_annotated)
  pvalue=no_loop_OE+no_loop_UE
}
print(x) #X axis threshold for p-value 0.05

# Histogram with threshold (dotted lines) and zoom in the y axis
ggplot(df_loops_and_no_loops_annotated, aes(CES, fill=Group, colour=Group)) +
  geom_histogram(aes(y=2*(..density..)/sum(..density..)), breaks=seq(-0.5,0.5,0.01), alpha=0.5, 
                 position="identity", lwd=0.2) +
  scale_y_continuous(labels=percent_format()) +
  ggtitle("Mean(logFC*-log10(p-value)) distribution") + 
  xlab("Mean(logFC*-log10(p-value)) per region") + 
  ylab("Pertentage") +
  geom_vline(xintercept = -x, linetype="dotted") +
  geom_vline(xintercept = x, linetype="dotted") +
  facet_zoom(ylim = c(0, 0.05))

# Percentage of overexpressed regions
loop_OE<-length(which(df_potential_loops_annotated$CES > x))/nrow(df_potential_loops_annotated)
no_loop_OE<-length(which(df_no_loops_annotated$CES > x))/nrow(df_no_loops_annotated)

# Percentage of underexpressed regions
loop_UE<-length(which(df_potential_loops_annotated$CES < -x))/nrow(df_potential_loops_annotated)
no_loop_UE<-length(which(df_no_loops_annotated$CES < -x))/nrow(df_no_loops_annotated)

# Percentage of regions with no significant changes
loop_cero<-length(which(df_potential_loops_annotated$CES < x & df_potential_loops_annotated$CES > -x))/nrow(df_potential_loops_annotated)
no_loop_cero<-length(which(df_no_loops_annotated$CES < x & df_no_loops_annotated$CES > -x))/nrow(df_no_loops_annotated)

# Pie chart of percentages for loops
myPalette <- brewer.pal(5, "Set2") 
Loop <- c(loop_OE*100,loop_UE*100,loop_cero*100)
pie(Loop, main="Loops", labels = c("Overexpressed","Underexpressed","No significant"), border="white", col=myPalette )

# Pie chart of percentages for no-loops
No_Loop <- c(no_loop_OE*100,no_loop_UE*100,no_loop_cero*100)
pie(No_Loop, main="No loops", labels = c("Overexpressed","Underexpressed","No significant"), border="white", col=myPalette )

# Correct by multiple testing (with benjamini hochberg method):
#
# x_adj is the threshold
# p_value is the percentage of no-loop regions (H0) that exceed the threshold
# p_adj_value is the percentage of loop regions that exceed a threshold
# multiplied by the FDR.
# The threshold increases until both the p-value and the adjusted p-value are 
# lower than 0.05 and the p-value is lower than the adjusted p-value.
#
# NOTE: In the Benjamini Hochberg correction, the adjusted p-value is 
# calculated by dividing the position in the ranking that the corresponding
# p-value occupies by the number of elements analyzed and multiplying by the
# FDR. This is equivalent to calculating the percentage of regions that exceed
# the threshold and multiplying it by the FDR, which is what we do in our code.
# 
p_value <- 1
p_adj_value <- 1
x_adj <- 0
FDR <- 0.25
while (p_adj_value > 0.05 | p_value > 0.05 | p_value >= p_adj_value) {
  x_adj = x_adj+0.0001
  p_value= length(which(df_no_loops_annotated$CES > x_adj | 
                          df_no_loops_annotated$CES < -x_adj))/nrow(df_no_loops_annotated)
  p_adj_value=length(which(df_potential_loops_annotated$CES > x_adj | 
                             df_potential_loops_annotated$CES < -x_adj))/nrow(df_potential_loops_annotated) * FDR
}
print(x_adj) #X axis threshold for p-value 0.05
print(p_value)
print(p_adj_value)

# Histogram with new threshold (dotted lines) and zoom in the y axis
ggplot(df_loops_and_no_loops_annotated, aes(CES, fill=Group, colour=Group)) +
  geom_histogram(aes(y=2*(..density..)/sum(..density..)), breaks=seq(-0.5,0.5,0.01), alpha=0.5, 
                 position="identity", lwd=0.2) +
  scale_y_continuous(labels=percent_format()) +
  ggtitle("Mean(logFC*-log10(p-value)) distribution") + 
  xlab("Mean(logFC*-log10(p-value)) per region") + 
  ylab("Pertentage") +
  geom_vline(xintercept = -x_adj, linetype="dotted") +
  geom_vline(xintercept = x_adj, linetype="dotted") +
  facet_zoom(ylim = c(0, 0.05))

# Diferentially expressed LOOP REGIONS selection

Loop_OE_regions <- df_potential_loops_annotated[which(df_potential_loops_annotated$CES > x_adj), ]
Loop_UE_regions <- df_potential_loops_annotated[which(df_potential_loops_annotated$CES < -x_adj), ]

dir.create("../Results/OE_and_UE_regions")

write.table(Loop_OE_regions, file="../Results/OE_and_UE_regions/Loop_OE_regions.bed", sep="\t", quote=F, row.names=F, col.names=F)
write.table(Loop_UE_regions, file="../Results/OE_and_UE_regions/Loop_UE_regions.bed", sep="\t", quote=F, row.names=F, col.names=F)

# Differentially expressed NO LOOP REGIONS selection

No_loop_OE_regions <- df_no_loops_annotated[which(df_no_loops_annotated$CES > x_adj), ]
No_loop_UE_regions <- df_no_loops_annotated[which(df_no_loops_annotated$CES < -x_adj), ]

dir.create("../Results/OE_and_UE_regions_no_loop")

write.table(No_loop_OE_regions, file="../Results/OE_and_UE_regions_no_loop/No_loop_OE_regions.bed", sep="\t", quote=F, row.names=F, col.names=F)
write.table(No_loop_UE_regions, file="../Results/OE_and_UE_regions_no_loop/No_loop_UE_regions.bed", sep="\t", quote=F, row.names=F, col.names=F)

