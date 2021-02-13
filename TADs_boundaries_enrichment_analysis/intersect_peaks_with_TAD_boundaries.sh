#!/bin/bash
#
# Author: Ana Rodriguez Ronchel
#
# Date: 25-11-2020
#
###################################### DESCRIPTION ############################
#
# This script converts .domain files that contains TAD coordinates in .bed 
# files. Then, for each TAD boundary (start=left and end=rigth), a +-500kb 
# window is analyzed in 10 bp segments. For each of these segments, the
# percentage of bp from lost or retained peaks that overlap with the segment is
# calculated and wrote in a file. 
#
# INPUT:
#   - Arg1: lost peaks file name (without .bed extension)
#   - Arg2: retained peaks file name (without .bed extension)
#   - Arg3: TAD coordinates file name (without .domains extension)
#
# OUTPUT:
#   - proportion.txt file that contains as many lines as 10 bp segments and 4
#     columns with the following information for each of those segments: % of
#     bp from lost peaks that overlap with left boundary, % of bp from retained
#     peaks that overlap with left boundary, % of bp from lost peaks that
#     overlap with right boundary and % of bp from retained peaks that overlap
#     with right boundary 
# 
###################################### REQUIREMENTS ###########################
# 
# The directory must be set to the file where this script is located. 
#
# The parent directoy must contain the next directories:
#     - DATA: .domains file with the TAD coordinates and .bed files with lost
#             and retained peaks obtained from the ChIP-Seq analysis with the
#             DiffBind_lost_vs_retained.R script. 
#     - SCRIPTS: this script
#     - RESULTS: empty
#
# Installed programs: sed, sort, bedtools, awk
#
##################################### RUN EXAMPLE #############################
#
# ./intersect_peaks_with_TAD_boundaries.sh Lost Retained mESC.Bonev_2017-raw
#
######################################### MAIN ################################

Lost_peaks=$1
Retained_peaks=$2
TADs_coord=$3

# Add "chr" prefix to the chromosome number to generate a .bed file

sed -e 's/^/chr/' ../DATA/$TADs_coord.domains >../DATA/$TADs_coord.bed

# Sort

sort -k1,1 -k2,2n ../DATA/$TADs_coord.bed > ../DATA/"$TADs_coord"_sorted.bed

# Generation of two files, one for left and other for rigth boundary of the
# TADs. The file is overwritten for each 10 bp segment in a window of +-500 bp 
# around the TAD boundary. The file contains as many lines as TADs regions 
# in the initial .domains file but, instead of TAD coordinates, it contains the
# coordinates of the corresponding 10 bp segment within the +-500 bp window. 

for start in {-500050..500050..10}
do 
	end=$(($start+10))
	awk -v start="$start" -v end="$end" '{ OFS="\t" }{ print $1, $2+start, $2+end }' ../DATA/"$TADs_coord"_sorted.bed > ../DATA/"$TADs_coord"_sorted_start_10bp.bed

	awk -v start="$start" -v end="$end" '{ OFS="\t" }{ print $1, $3+start, $3+end }' ../DATA/"$TADs_coord"_sorted.bed > ../DATA/"$TADs_coord"_sorted_end_10bp.bed

	############################ INTERSECTION #############################

	# Generation of files that contains those fragments of lost or retained
	# peaks that overlap with the corresponding 10 bp segments.


	# Left boundary with lost peaks

	bedtools intersect -a ../DATA/$Lost_peaks.bed -b ../DATA/"$TADs_coord"_sorted_start_10bp.bed > ../RESULTS/intersect_peaks_lost_TADs_start.bed

	# Right boundary with lost peaks

	bedtools intersect -a ../DATA/$Lost_peaks.bed -b ../DATA/"$TADs_coord"_sorted_end_10bp.bed > ../RESULTS/intersect_peaks_lost_TADs_end.bed

	# Left boundary with retained peaks

	bedtools intersect -a ../DATA/$Retained_peaks.bed -b ../DATA/"$TADs_coord"_sorted_start_10bp.bed > ../RESULTS/intersect_peaks_retained_TADs_start.bed

	# Right boundary with retained peaks 

	bedtools intersect -a ../DATA/$Retained_peaks.bed -b ../DATA/"$TADs_coord"_sorted_end_10bp.bed > ../RESULTS/intersect_peaks_retained_TADs_end.bed


	############################### COUNTING ##############################

	# Analyzing the number of bp contained in the overlap file and the
        # percentage they assume of the total bp contained in lost or retained
	# peaks.

	# Total amount of bp in lost or retained peaks

	bp_lost=$(awk 'BEGIN{FS= "\t"; bp=0} {bp+=($3-$2)} END{print bp}' ../DATA/$Lost_peaks.bed)

	bp_retained=$(awk 'BEGIN{FS= "\t"; bp=0} {bp+=($3-$2)} END{print bp}' ../DATA/$Retained_peaks.bed)

	# Amount of bp in the overlap files

	bp_lost_in_inicio_TADs=$(awk 'BEGIN{FS= "\t"; bp=0} {bp+=($3-$2)} END{print bp}' ../RESULTS/intersect_peaks_lost_TADs_start.bed)

	bp_retained_in_inicio_TADs=$(awk 'BEGIN{FS= "\t"; bp=0} {bp+=($3-$2)} END{print bp}' ../RESULTS/intersect_peaks_retained_TADs_start.bed)

	bp_lost_in_fin_TADs=$(awk 'BEGIN{FS= "\t"; bp=0} {bp+=($3-$2)} END{print bp}' ../RESULTS/intersect_peaks_lost_TADs_end.bed)

	bp_retained_in_fin_TADs=$(awk 'BEGIN{FS= "\t"; bp=0} {bp+=($3-$2)} END{print bp}' ../RESULTS/intersect_peaks_retained_TADs_end.bed)

	# Percentage of total bp that overlap.

	proporcion_bp_lost_in_inicio_TADs=$(bc <<<"scale=10;$bp_lost_in_inicio_TADs/$bp_lost*100")

	proporcion_bp_retained_in_inicio_TADs=$(bc <<<"scale=10;$bp_retained_in_inicio_TADs/$bp_retained*100")

	proporcion_bp_lost_in_fin_TADs=$(bc <<<"scale=10;$bp_lost_in_fin_TADs/$bp_lost*100")

	proporcion_bp_retained_in_fin_TADs=$(bc <<<"scale=10;$bp_retained_in_fin_TADs/$bp_retained*100")

	# Writting the percentages in a file.

	echo $proporcion_bp_lost_in_inicio_TADs	$proporcion_bp_retained_in_inicio_TADs	$proporcion_bp_lost_in_fin_TADs $proporcion_bp_retained_in_fin_TADs >> ../RESULTS/proportions.txt

done


# Remove intermediate files generated in the last loop.

rm ../DATA/$TADs_coord.bed
rm ../DATA/"$TADs_coord"_sorted.bed
rm ../DATA/"$TADs_coord"_sorted_start_10bp.bed
rm ../DATA/"$TADs_coord"_sorted_end_10bp.bed
rm ../RESULTS/intersect_peaks_lost_TADs_start.bed
rm ../RESULTS/intersect_peaks_lost_TADs_end.bed
rm ../RESULTS/intersect_peaks_retained_TADs_start.bed
rm ../RESULTS/intersect_peaks_retained_TADs_end.bed




