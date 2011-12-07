clear
reset
file="TEM-moden"
set key inside top right
set xlabel 'x'
set ylabel 'A(x)'
set samples 100000
set xrange [0:pi]
set yrange [-1:2]
unset xtics
unset ytics

f(x,a) = sin(a*x)


#set label 1 sprintf('$\chi^2_{\mathrm{red}} = %.4f$',FIT_WSSR/FIT_NDF) at graph 0.02, 0.80

set term push
set term epslatex color 10
set out sprintf('%s.tex',file)

plot f(x,1) title "fundamentale Mode" lt 1 lc 1, \
f(x,2) title "1. Harmonische" lt 1 lc 2, \
f(x,3) title "2. Harmonische" lt 1 lc 3

unset out
set term pop