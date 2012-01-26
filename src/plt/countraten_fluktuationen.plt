clear
reset
file = "countraten_fluktuationen"
datafile = sprintf('../dat/%s.dat',file)

set samples 100000
set term push
set term epslatex color 10
set out sprintf('%s.tex',file)

set key inside top right
set xlabel 'Integrationszeit [s]'
set ylabel 'Fluktuation [\%]'

plot datafile using 1:2 with linespoints ls 1 lc 1 title 'altes System', \
datafile using 1:3 with linespoints ls 1 lc 3 title 'neues System'

unset out


