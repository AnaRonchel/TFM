# Author: Ana Rodríguez Ronchel
# Date 29/11/2020
# Description: Representation of the overlap between peaks and TAD boundaries.
# Requirements: the parent directory must have a RESULT file with the files
#               obtained from the analysis done with the bash script:
#               intersect_peaks_with_TAD_boundaries.sh
# Output: plots with que peak overlap profile 500kb around the TAD left and
#         right boundaries. 

# Packages:

#install.packages("tidyverse")
library("ggplot2")
library(reshape2)
#install.packages("ggpubr") #To calculate the p-value of the differences between two groups
library(ggpubr)
library(ggforce)
library(lattice)
library(scales) # For percent_format()
library(RColorBrewer) # For colours of th pie chart
myPalette <- brewer.pal(5, "Set2") 


# LOAD DATA
df <- read.csv("../RESULTS/proportions.txt", sep=" ", header = FALSE)
names(df) <- c("Lost_start","Retained_start","Lost_end", "Retained_end")

# Individual plots
barplot(df$Lost_start)
barplot(df$Retained_start)
barplot(df$Lost_end)
barplot(df$Retained_end)

# Kolmogorov-Smirnov Tests to study if the overlap
# distributions in lost and retained groups of peaks
# are significantly different.  
ks.test(df$Lost_start, df$Retained_start)
ks.test(df$Lost_end, df$Retained_end)

# We then generate a list with the average overlap percentage of each region 
# and the 6000 surrounding regions. This allowed for smoothing the changes 
# between the percentages obtained for neighbouring regions. 

df_smooth_lost_start <- filter(df$Lost_start, rep(1/5999, 5999), sides=2)
df_smooth_retained_start <- filter(df$Retained_start, rep(1/5999, 5999), sides=2)
df_smooth_lost_end <- filter(df$Lost_end, rep(1/5999, 5999), sides=2)
df_smooth_retained_end <- filter(df$Retained_end, rep(1/5999, 5999), sides=2)

# In the next plots these average values will be represented as a line over the 
# histogram generated with the raw values to facilitate the visualisation of 
# the data.

require(gridExtra)

# Plot of the left TAD bounday
plot_left <- ggplot(data=df, aes(x=seq(-500.050, 500.050, by=0.01))) +
  geom_bar(aes(y=Retained_start), stat="identity", position ="identity", alpha=0.8, set_palette(5, palette="Set2"), fill="paleturquoise3") +
  geom_bar(aes(y=Lost_start), stat="identity", position="identity", alpha=0.8, set_palette(5, palette="Set2"), fill="lightpink2") +
  geom_line(aes(y=df_smooth_retained_start), color="lightseagreen", size=1) +
  geom_line(aes(y=df_smooth_lost_start), color="lightpink3", size=1) +
  ggtitle("Left TAD boundary") + 
  xlab("Distance from TAD boundary (kb)") + 
  ylab("Overlap pertentage")

# Plot of the right TAD boundary
plot_right <- ggplot(data=df, aes(x=seq(-500.050, 500.050, by=0.01))) +
  geom_bar(aes(y=Retained_start), stat="identity", position ="identity", alpha=0.8, set_palette(5, palette="Set2"), fill="paleturquoise3") +
  geom_bar(aes(y=Lost_start), stat="identity", position="identity", alpha=0.8, set_palette(5, palette="Set2"), fill="lightpink2") +
  geom_line(aes(y=df_smooth_retained_end), color="lightseagreen", size=1) +
  geom_line(aes(y=df_smooth_lost_end), color="lightpink3", size=1) +
  ggtitle("Rigth TAD boundary") + 
  xlab("Distance from TAD boundary (kb)") + 
  ylab("Overlap pertentage")

# To generate a image with both plots together 
grid.arrange(plot_left, plot_right, ncol=2)
  
