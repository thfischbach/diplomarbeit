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
		
def elementFound(list,element):
	found = False
	for e in list:
		if e == element:
			found = True
	return found

def mean(numberList):
	if len(numberList) == 0:
		return float('nan')
	floatNums = [float(x) for x in numberList]
	return sum(floatNums) / len(numberList)

input = sys.argv[1]
output = sys.argv[2]
inputFile = open(sys.argv[1],"r")
outputFile = open(sys.argv[2],"w")
lines = []
valuesDone = []
meanTemp = []

for line in inputFile:
	lines.append(line.split("	"))
for line in lines:
	x1 = float(line[0])
	if not elementFound(valuesDone,x1):
		#print('found new value: ' + str(x1))
		valuesDone.append(x1)
		del meanTemp[0:len(meanTemp)]
		for line in lines:
			x2 = float(line[0])
			y2 = float(line[1])
			if x1 == x2:
				meanTemp.append(y2)
				if len(meanTemp) > 1:
					print('found twin value for ' + str(x1) + ': ' + str(y2))
		yMean = mean(meanTemp)
		if len(meanTemp) > 1:
			print(str(meanTemp) + ' -> ' + str(yMean))
		outputFile.write(str(x1) + '\t' + str(yMean) + "\n")
	else:
		print('found already existing value: ' + str(x1))