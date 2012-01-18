clear
reset
file = "beatfrequenzen_neu_iScan_drift"
datafile = sprintf('../dat/%s.dat',file)

unset key
set xlabel 'Messpunkt #'
#set format x "%.0f"
set ylabel 'Schwebungsfrequenz [MHz]'
set samples 100000

set style rect fc lt -1 fs solid 0.15 noborder
set obj rect from 0, graph 0 to 423, graph 1


set term push
set term epslatex color 10
set out sprintf('%s.tex',file)

plot datafile with errorbars, \
datafile using 1:2 with lines lt 1 lc 2

unset out