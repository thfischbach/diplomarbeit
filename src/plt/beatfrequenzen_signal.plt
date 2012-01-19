clear
reset
file = "beatfrequenzen_signal"
datafile = sprintf('../dat/%s.dat',file)

unset key
set xlabel 'Zeit [ns]'
#set format x "%.0f"
set ylabel 'Amplitude [mV]'
set samples 100000
set tmargin 0

set term push
set term epslatex color 10 size 14cm, 7cm
set out sprintf('%s.tex',file)

plot datafile using ($1*1000000000+250):($2*1000) with lines lt 1 lc 3

unset out