clear
reset
file = "beatfrequenzen_neu_iScan+FOL_drift"
datafile = sprintf('../dat/%s.dat',file)

unset key
set xlabel 'Zeit [min]'
#set format x "%.0f"
set ylabel 'Schwebungsfrequenz [MHz]'
set samples 100000

set label 1 '\textit{iScans}: aktiv' at graph 0.2,0.15 front
set label 2 'FOL: aktiv' at graph 0.2,0.08 front
set label 3 '\textit{iScans}: aktiv' at graph 0.7,0.15 front
set label 4 'FOL: inaktiv' at graph 0.7,0.08 front

set style rect back fc lt -1 fs solid 0.15 noborder
set obj rect from 0, graph 0 to 53, graph 1 behind

set term push
set term epslatex color 10
set out sprintf('%s.tex',file)

plot datafile using ($1/2124*79):2:3 with errorbars, \
datafile using ($1/2124*79):2 with lines lt 1 lc 2
unset out