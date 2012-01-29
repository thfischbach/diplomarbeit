clear
reset
file = "linearisierung_FSR_okay"
datafile = sprintf('../dat/%s.dat',file)

unset key
set samples 100000
set term push
set term epslatex color 10 size 13cm, 12cm
set out sprintf('%s.tex',file)
set multiplot

set lmargin 10
set rmargin 10

set logscale y
set yrange [0.5:400]
set xrange [0:11]
set xtics 1,1,10
#set grid ytics lt 1 lc rgbcolor "#f4f4f4" linewidth .1
#set grid mytics lt 1 lc rgbcolor "#fafafa" linewidth .1
set ylabel 'max. Scanfehler [MHz]'
unset xlabel
set origin 0, 0.5
set size 1, 0.5
set bmargin 0.3
set tmargin 5
#set lmargin 10
set format x ""

plot datafile using 1:(abs($2)) with lines, \
datafile using 1:(abs($2)) with points pt 2 lc 2


set ylabel 'FSR Fehler [MHz]'
set xlabel 'Iteration'
#unset logscale y
#unset grid
#set ytics 0,1,4
set yrange [0.1:7]
set origin 0, 0
set size 1, 0.5
set bmargin 5
set tmargin 0.3
#set lmargin 8.2
set format x "%g"

plot datafile using 1:(abs($4)) with lines, \
datafile using 1:(abs($4)) with points pt 2 lc 2

unset multiplot
unset out
