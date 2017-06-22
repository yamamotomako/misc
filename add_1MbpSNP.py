#! /usr/bin/env python

import sys
import os
import pysam
#import tabix

inpdir = sys.argv[1]
outdir = sys.argv[2]


for file in os.listdir(inpdir):

    samplename = file.rstrip("\n").replace(".genomon_mutation.result.filt.txt", "")
    print "add snp around: " + samplename

    with open(inpdir + "/" + file, "r") as f:
        g = open(outdir + "/" + samplename + ".addsnp", "w")

        for line in f:
            data = line.split("\t")
            chrm = data[0]
            start = data[1]
            end = data[2]

            #if chrm == "X":
            #    chrm = 22
            #elif chrm == "Y":
            #    chrm = 23
            #else:
            #    chrm = int(chrm)-1

            span = 100000

            url = "/home/ymako/calc_feature/filt_bgzip/" + samplename + ".filt.snp.gz"
            #tb = tabix.open(url)
            #records = tb.queryi(chrm, int(start)-int(span), int(end)+int(span))

            misRate_str = ""
            depth_str = ""
            variant_str = ""


            tbx = pysam.TabixFile(url)
            for r in tbx.fetch("chr"+chrm, int(start)-int(span), int(end)+int(span), parser=pysam.asTuple()):
            #for r in records:
                misRate_t = r[5]
                depth_t = r[6]
                variant_t = r[7]

                misRate_str += misRate_t + ","
                depth_str += depth_t + ","
                variant_str += variant_t + ","

            g.write(line.rstrip("\n") + "\t" + misRate_str[:-1] + "\t" + depth_str[:-1] + "\t" + variant_str[:-1] + "\n")

        g.close()





