# Date: 17/10/2020
# Description: Peak length representations.
# Requirements: the parent directory must have a Results file with bed 
#               files for the retained and lost peaks obtained with the
#               DiffBind_lost_vs_retained.R script.
# Output: Boxplot and histogram with peak size distribution information.

#Packages:

#install.packages("tidyverse")
library("ggplot2")
#install.packages("ggpubr") #To calculate the p-value of the differences between two groups
library(ggpubr)
library(ggforce)
library(lattice)
library(scales) # For percent_format()

# Load data 
Lost_peaks <- read.csv("../Results/Lost.bed", sep="\t", header = FALSE)[ ,1:3]
names(Lost_peaks) <- c("Chr","Start","End")
Retained_peaks <- read.csv("../Results/Retained.bed", sep="\t", header = FALSE)[ ,1:3]
names(Retained_peaks) <- c("Chr","Start","End")

# Now, combine your two dataframes into one.  

# First make a new column in each that will be 
# a variable to identify where they came from later.
Lost_peaks$Group <- 'Lost'
Retained_peaks$Group <- 'Retained'

# and combine into your new data frame
df_lost_and_retained <- rbind(Lost_peaks, Retained_peaks)

# t-test
t.test(End-Start ~ Group, data = df_lost_and_retained)

# Histogram
ggplot(df_lost_and_retained, aes(End-Start, fill=Group, colour=Group)) +
  geom_histogram(aes(y=2*(..density..)/sum(..density..)), breaks=seq(0,4000,1), alpha=0.5, 
                 position="identity", lwd=0.2) +
  scale_y_continuous(labels=percent_format()) +
  ggtitle("Peak size distribution") + 
  xlab("Peak size (bp)") + 
  ylab("Pertentage")

# Boxplot
size_boxplot <- ggplot(df_lost_and_retained, aes(x=Group, y=End-Start, fill=Group)) + 
  geom_boxplot(alpha=0.6) +
  theme(legend.position="none")

size_boxplot + 
  ggtitle("Peak size boxplot") + 
  xlab("Group") + 
  ylab("Peak size (bp)") + 
  labs(fill = "Group") +
  stat_compare_means(method = "wilcox.test", label = "p.signif", size = 8, label.x = 1.4, label.y=4000)

# Histogram
size_hist <- ggplot(df_lost_and_retained, aes(End-Start, fill = Group)) + 
  geom_density(alpha=0.3)

size_hist + 
  ggtitle("Peak size distribution") + 
  xlab("Peak size (bp)") + 
  ylab("Density") + 
  labs(fill = "Group")

