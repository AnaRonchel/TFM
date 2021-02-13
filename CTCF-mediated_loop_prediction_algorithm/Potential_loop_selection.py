#!/usr/bin/env python

# Author: Ana Rodriguez Ronchel
# Date: 18-11-2020
# Description: This script generates a bed file with the coordinates of the
#              genome regions that could correspond with DNA loops that were
#              present in a control condition but not in a CTCF-deficient
#              condition. It makes a filter based on:
#                 - At least one of the extremes of the potential loop region
#                   must be a lost peak (binding sites presentes en the control
#                   group but not in the CTCF-deficient group)
#                 - The motif at the left side must be at the + strand and
#                   the motif at the rigth side at the - strand
#                 - A loop can not be formed by two motifs present in the same
#                   peak because the distance is too short.
#                 - A loop can not be formed by two motifs with a distance
#                   grater than 100kb.
# Input:
#       - Arg1: 4 column bed file with lost peaks (chr, star, end, motif strand)
#       - Arg2: 4 column bed file with retained peaks (")
# Output:
#       - 3 column bed file with potential loops coordinates (shr, start, end)
#
# Execution example:
# ./Potential_loop_selection.py ../Results/Annotated_files/Annotated_Lost_peaks.bed ../Results/Annotated_files/Annotated_Retained_peaks.bed

################################# MAIN #########################################

# Argument import and variable asignation:
import sys
lost_peaks = sys.argv[1]
retained_peaks = sys.argv[2]

# Make a dictionary of lost peaks
chr_dict_lost = {}
with open(lost_peaks, 'r') as lost_file:
    for line in lost_file:
        chr = line.strip().split()[0]
        if chr not in chr_dict_lost.keys():
            chr_dict_lost[chr]=[]
        chr_dict_lost[chr].append(line.strip().split()[1:4]) #Dict with a list
                                                             #of (start, end,
                                                             #strand) for each
                                                             #chr.

# Make a dictionary of retained peaks
chr_dict_retained = {}
with open(retained_peaks, 'r') as retained_file:
    for line in retained_file:
        chr = line.strip().split()[0]
        if chr not in chr_dict_retained.keys():
            chr_dict_retained[chr]=[]
        chr_dict_retained[chr].append(line.strip().split()[1:4])


#Open a new file to write all the potential loops:
file_write = open("../Results/Potential_loop_file/potential_loops.bed", 'w')

#ADDING LOOPS THAT START AND END WITH A LOST PEAK:
for key in chr_dict_lost.keys():
    for peak_1 in chr_dict_lost[key]: #First loop that select only + peaks
        if peak_1[2] != "+":
            continue
        for peak_2 in chr_dict_lost[key]: #Second loop that select - peaks
            if int(peak_2[0]) - int(peak_1[0]) <= 0: continue #To avoid select two motifs of the same peak.
            if int(peak_2[1]) - int(peak_1[0]) >= 100000: break
            if peak_2[2] == "-":
                possible_loop=[key,peak_1[0],peak_2[1]]
                for column in possible_loop:
                    file_write.write(column)
                    file_write.write("\t")
                file_write.write("\n")

#ADDING LOOPS THAT START WITH A LOST PEAK BUT END WITH A RETAINED LOOP
for key in chr_dict_lost.keys():
    if key in chr_dict_retained.keys():
        for peak_1 in chr_dict_lost[key]: #First loop that select only + peaks
            if peak_1[2] != "+":
                continue
            for peak_2 in chr_dict_retained[key]: #Second loop that select - peaks
                if int(peak_2[0]) - int(peak_1[0]) <= 0: continue #To avoid select two motifs of the same peak.
                if int(peak_2[1]) - int(peak_1[0]) >= 100000: break
                if peak_2[2] == "-":
                    possible_loop=[key,peak_1[0],peak_2[1]]
                    for column in possible_loop:
                        file_write.write(column)
                        file_write.write("\t")
                    file_write.write("\n")

#ADDING LOOPS THAT START WITH A RETAINED PEAK BUT END WITH A LOST LOOP
for key in chr_dict_retained.keys():
    if key in chr_dict_lost.keys():
        for peak_1 in chr_dict_retained[key]: #First loop that select only + peaks
            if peak_1[2] != "+":
                continue
            for peak_2 in chr_dict_lost[key]: #Second loop that select - peaks
                if int(peak_2[0]) - int(peak_1[0]) <= 0: continue #To avoid select two motifs of the same peak.
                if int(peak_2[1]) - int(peak_1[0]) >= 100000: break
                if peak_2[2] == "-":
                    possible_loop=[key,peak_1[0],peak_2[1]]
                    for column in possible_loop:
                        file_write.write(column)
                        file_write.write("\t")
                    file_write.write("\n")

file_write.close()
