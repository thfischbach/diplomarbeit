clear
reset
file = "linearitaet_verlauf"
datafile = sprintf('../dat/%s.dat',file)

unset key
set samples 100000
set term push
set term epslatex color 10 size 14cm, 14cm
set out sprintf('%s.tex',file)
set multiplot

set yrange [0:100]
set ylabel 'max. Scanfehler [MHz]'
unset xlabel
set ytics 10,10,100
set origin 0, 0.5
set size 1, 0.5
set bmargin 0.3
set tmargin 5
#set lmargin 10
set xdata time
set timefmt "%d.%m.%Y %H:%M:%S"
set format x ""

plot datafile using 5:2 with lines, \
datafile using 5:2 with points pt 2 lc 2


set ylabel 'FSR Fehler [MHz]'
set xlabel 'Zeit'
set format x "%H:%M"
set mxtics 3
set ytics -6,2,6
set yrange [-8:8]
set origin 0, 0
set size 1, 0.5
set bmargin 5
set tmargin 0.3
set lmargin 8.2

plot datafile using 5:4 with lines, \
datafile using 5:4 with points pt 2 lc 2

unset multiplot
unset out
