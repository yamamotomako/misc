#! /usr/bin/env python

import os, sys, re

if len(sys.argv) != 4:
    print "Usage: python categorize.py ./input_dir ./output_file_path category"
    quit()

category = sys.argv[1]
inputdir = sys.argv[2]
outfile = sys.argv[3]



#snp138
if category == "somatic":
    col_snp = 19
else:
    col_snp = 19

#cosmic70
if category == "somatic":
    col_cosmic = 23
else:
    col_cosmic = 23

#ExAc frequency
if category == "somatic":
    col_exac = 91
else:
    col_exac = 80


result = open(outfile, "w")

#header
arr = ["sample","chr","start","ref","alt","category","dbSNP","cosmic","ExAC"]
result.write("\t".join(arr) + "\n")


files = os.listdir(inputdir)
for file in files:
    with open(inputdir + "/" + file, "r") as f:
        for line in f:
            sample = re.sub(r"[N|T].genomon_mutation.result.filt.txt", "", file)
            data = line.split("\t")
            chrm = data[0]
            start = data[1]
            #end = data[2]
            ref = data[3]
            alt = data[4]
            dbsnp = data[col_snp]
            cosmic = data[col_cosmic]
            exac = data[col_exac]            

            dbsnp_flag = False
            cosmic_all = 0

            if dbsnp != "":
                dbsnp_flag = True

            if cosmic != "":
                cosmic_slice = cosmic[cosmic.find("OCCURENCE="):]
                cosmic_num = re.compile(r"\d").findall(cosmic_slice)
                for num in cosmic_num:
                    cosmic_all += int(num)

            if exac == "---":
                exac = 0

            arr = [sample, chrm, start, ref, alt, category, str(dbsnp_flag), str(cosmic_all), str(exac)]
            result.write("\t".join(arr) + "\n")

result.close()











