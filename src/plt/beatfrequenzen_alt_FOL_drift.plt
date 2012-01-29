clear
reset
file = "beatfrequenzen_alt_FOL_drift"
datafile = sprintf('../dat/%s.dat',file)

unset key
set xlabel 'Zeit [min]'
#set format x "%.0f"
set ylabel 'Schwebungsfrequenz [MHz]'
set samples 100000

set term push
set term epslatex color 10
set out sprintf('%s.tex',file)

plot datafile using ($1/1101*30):2:3 with errorbars, \
datafile using ($1/1101*30):2 with lines lt 1 lc 2

unset out