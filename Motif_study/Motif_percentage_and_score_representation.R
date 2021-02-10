# Author: Ana Rodríguez Ronchel
# Date 12/11/2020
# Description: Motif analysis results representation.
# Requirements: the parent directory must have a Result file with the files
#               obtained with Motif_analysis.sh script.
# Output: plots of the percentaje of peaks with a CTCF motif (numbers obtained 
#         from the knownResults.html file) and of the motif score distribution.

# Packages:

#install.packages("tidyverse")
#install.packages("ggpubr") #To calculate the p-value of the differences between two groups
library(ggpubr)
library(dplyr)
library(tidyr)
library(ggplot2)

# LOAD DATA

df_lost <- read.csv("../Results/Lost_annotated.txt", sep="\t")
df_retained <- read.csv("../Results/Retained_annotated.txt", sep="\t")

# Now, combine your two dataframes into one.  
# First make a new column in each that will be 
# a variable to identify where they came from later.
df_lost$Group <- 'Lost'
df_retained$Group <- 'Retained'

# and combine into your new data frame
df_peaks <- rbind(df_lost, df_retained)

# To study the significance
t.test(MotifScore ~ Group, data = df_peaks) 
compare_means(MotifScore ~ Group, data = df_peaks)

# MOTIF SCORES BOXPLOT
motif_score_boxplot <- ggplot(df_peaks, aes(x=Group, y=MotifScore, fill=Group)) + 
  geom_boxplot(alpha=0.6) +
  theme(legend.position="none")

motif_score_boxplot + 
  ggtitle("Motif score boxplot") + 
  xlab("Group") + 
  ylab("Motif score") + 
  labs(fill = "Group") +
  stat_compare_means(method = "wilcox.test", label = "p.signif", size = 8, label.x = 1.4, label.y=17)


# Percentage of peaks with CTCF motifs barchart (numbers obtained
# from the knownResults.html file.

dat <- data.frame(
  motif = c(35.76, 71.92),
  Group = as.factor(c("Lost", "Retained")))

dat_long <- dat %>%
  gather("Stat", "Value", -Group)

dat_long

ggplot(dat_long, aes(x = Group, y = Value, fill = Group)) +
  geom_col(position = "dodge", alpha=0.6) +
  ylim(0,100) +
  ggtitle("CTCF motif within peaks") + 
  ylab("Percentage of peaks with CTCF motif")
  
           

