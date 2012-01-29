clear
reset
file = "laserscan_LUT-kalibriert"
datafile = sprintf('../dat/%s.dat',file)

starttime = 27377708

set samples 100000
set term push
set term epslatex color 10 size 13cm, 7cm
set out sprintf('%s.tex',file)

set key

set yrange [-100:8000]
set key inside
set ylabel 'Frequenzverschiebung [MHz]'
set xlabel 'Zeit [s]

plot datafile using ($1-starttime)/1000:3 with lines title 'Soll-Frequenz', \
datafile using ($1-starttime)/1000:4 with points pt 6 lc 2 title 'Ist-Frequenz'

unset out
