# DATE: 13/01/2021
#
# AUTHOR: Ana Rodriguez Ronchel
#
# DESCRIPTION: This script processes the output file of the script 
#              "step8_OE_UE_no_loop_annotation_and_proportion_comm_genes.sh"
#              to know what is the average number of DEGs included in the 
#              no loop regions with a significant CES selected with the
#              script "step5_loop_and_no_loop_features.R"
                                                             
#Mean DEGs genes No loop file 
df_no_loops <- read.csv("../Results/No_loop_regions_annotated/common_genes_no_loops_DEGs_number.txt", sep="\t", header = FALSE)
hist(df_no_loops$V1)
mean(df_no_loops$V1)