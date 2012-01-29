#!/usr/bin/python

import sys
import locale
import time
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

def timestampToUnix(timestamp):
	return int(time.mktime(time.strptime(timestamp, '%d.%m.%Y %H:%M:%S'))) - time.timezone 

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
	if isFloat(line[0]):
		#print(str(line[4]).strip("\n"))
		outputFile.write(str(line[0]) + '\t' + str(line[1]) + '\t' + str(line[2]) + '\t' + str(line[3]) + '\t' + str(timestampToUnix(line[4].strip("\n"))) + "\n")
		print('converted \"' + str(line[4]).strip("\n") + '\" to \"' + str(timestampToUnix(str(line[4]).strip("\n"))) + '\"')
		#print(str(int(time.mktime(time.strptime('01.08.2011 17:54:09', '%d.%m.%Y %H:%M:%S')))))