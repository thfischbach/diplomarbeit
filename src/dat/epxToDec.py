#!/usr/bin/python

import sys
import locale
from decimal import *

locale.setlocale( locale.LC_ALL, 'C' ) 

def isFloat(s):
    try:
        dummy = float(s)
        return True
    except:
        return False

input = sys.argv[1]
output = sys.argv[2]
inputFile = open(sys.argv[1],"r")
outputFile = open(sys.argv[2],"w")
for line in inputFile:
	lineSplit = line.split("\t")
	if isFloat(lineSplit[0]):
		x = Decimal(lineSplit[0])
		y = Decimal(lineSplit[1])
		outputFile.write(str(x) + '\t' + str(y) + "\n")