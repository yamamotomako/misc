#! /usr/bin/env python

import sys
import os
from collections import OrderedDict


inpdir = sys.argv[1]
outfile = sys.argv[2]

ref_dict = OrderedDict()


for file in os.listdir(inpdir):
    with open(inpdir + "/" + file, "r") as f:
        print "create cohoto: " + file.replace(".genomon_mutation.result.filt.txt","")
        cnter = 0

        for line in f:
            cnter += 1
            if cnter < 5:
                continue

            data = line.rstrip("\n").split("\t")
            chrm = data[0]
            start = data[1]
            end = data[2]
            ref = data[3]
            alt = data[4]

            if ref == "-" or alt == "-":
                continue

            key = chrm + "_" + start + "_" + end + "_" + ref + "_" + alt

            if not key in ref_dict:
                ref_dict[key] = 0
            else:
                ref_dict[key] += 1

            

g = open(outfile, "w")
g.write("chr_start_end_ref_alt" + "\t" + "cohoto_count" + "\n")

for key, value in ref_dict.items():
    g.write(key + "\t" + str(value) + "\n")


g.close()


