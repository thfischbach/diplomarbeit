clear
reset
file = "laserscan_LUT-reset"
datafile = sprintf('../dat/%s.dat',file)

starttime = 22735306

set samples 100000
set term push
set term epslatex color 10 size 13cm, 7cm
set out sprintf('%s.tex',file)

set key

set yrange [-4000:4000]
set key inside
set ylabel 'Frequenzverschiebung [MHz]'
set xlabel 'Zeit [s]

plot datafile using ($1-starttime)/1000:3 with lines title 'Soll-Frequenz', \
datafile using ($1-starttime)/1000:4 with points pt 6 lc 2 title 'Ist-Frequenz'

unset out
