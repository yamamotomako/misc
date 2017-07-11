#! /usr/bin/env python


import sys
import math


#parameter
k = 30
n = 100
a = 10
b = 0.1




#calc beta-binominal distribution
#C = math.factorial(n) / (math.factorial(k) * math.factorial(n - k))
C = math.lgamma(n + 1) - math.lgamma(k + 1) - math.lgamma(n - k + 1)
B_frac = math.lgamma(a) * math.lgamma(b) - math.lgamma(a + b)
B_deno = math.lgamma(a + k) * math.lgamma(b + n - k) -  math.lgamma(a + b + n)



print "%.10f" % float(B_frac)
print "%.10f" % float(B_deno)


P = C * B_frac / B_deno



print "%.10f" % P
