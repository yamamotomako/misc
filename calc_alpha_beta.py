#! /usr/bin/env python


import sys
import os
import numpy
import optimize

inpfile = sys.argv[1]
outfile = sys.argv[2]


with open(inpfile, "r") as f:
    g = open(outfile, "w")
    header_arr = ["sample","chr","start","depth","variant","misrate_othersnp","depth_othersnp","variant_othersnp","alpha","beta"]
    g.write("\t".join(header_arr)+"\n")

    for line in f:
        data = line.split("\t")
        chrm = data[0]
        start = data[1]
        end = data[2]
        depth = data[3]
        variant = data[4]
        tumor_misrate = data[5]
        other_misrate = data[6]
        other_depth = data[7]
        other_variant = data[8]

        m_arr = other_misrate.split(",")
        d_arr = other_depth.split(",")
        v_arr = other_variant.split(",")

        m_new = []
        d_new = []
        v_new = []

        for i in range(len(m_arr)):
            m = m_arr[i]
            d = d_arr[i]
            v = v_arr[i]

            #remove blank
            if m == "":
                continue


            if float(m) < 0.95 and (int(d) - int(v)) >= 3:
                if (int(d) - int(v)) < int(v):
                    #print m, d, v
                    v = int(d) - int(v)
                    m = float(int(v)) / int(d)

                m_new.append("%03.3f" % float(m))
                d_new.append(int(d))
                v_new.append(int(v))


        #if len(m_new) == 0:
        #    continue

        fit = optimize.fit_beta_binomial(numpy.array(d_new), numpy.array(v_new))
        alpha = fit[0]
        beta = fit[1]

        content_arr = [inpfile, str(chrm), str(start), str(depth), str(variant), ",".join(m_new), ",".join(map(str,d_new)), ",".join(map(str,v_new)), str(alpha), str(beta)]
        g.write("\t".join(content_arr)+"\n")


    g.close()






