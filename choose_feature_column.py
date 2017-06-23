#! /usr/bin/env python

import os, sys, re

if len(sys.argv) != 4:
    print "Usage: python categorize.py ./input_dir ./output_file_path category"
    quit()

category = sys.argv[1]
inputdir = sys.argv[2]
outfile = sys.argv[3]

c = category

#misRate_tumor
if c == "A":
    col_misrate = 58
elif c == "B":
    col_misrate = 54
else:
    col_misrate = 54


#depth_tumor
if c == "A":
    col_depth = 50
elif c == "B":
    col_depth = 50
else:
    col_depth = 50


#variantNum_tumor
if c == "A":
    col_variant = 51
elif c == "B":
    col_variant = 51
else:
    col_variant = 51


#snp138
if c == "A":
    col_snp = 19
elif c == "B":
    col_snp = 19
else:
    col_snp = 19

#cosmic70
if c == "A":
    col_cosmic = 23
elif c == "B":
    col_cosmic = 23
else:
    col_cosmic = 23

#ExAc frequency
if c == "A":
    col_exac = 91
elif c == "B":
    col_exac = 80
else:
    col_exac = 80

#misRate_otherSNP
if c == "A":
    col_exac = 96
elif c == "B":
    col_exac = 85
else:
    col_exac = 85


result = open(outfile, "w")

#header
arr = ["sample","chr","start","ref","alt","category","dbSNP","cosmic","ExAC","misRate","depth","variantNum","cohoto_count","misRate_otherSNP","depth_otherSNP","variantNum_otherSNP"]
result.write("\t".join(arr) + "\n")


files = os.listdir(inputdir)
for file in files:
    with open(inputdir + "/" + file, "r") as f:
        for line in f:
            sample = re.sub(r"[N|T].addsnp", "", file)
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











