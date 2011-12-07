clear
reset
file="fano"
set key inside top left
set xlabel '$\epsilon$'
set ylabel '$\sigma$'
set samples 100000
set xrange [-5:5]
set yrange [-1:18]

f(q,E) = (q*g/2+E-E0)**2/((E-E0)**2+(g/2)**2)
g=2
E0=0
#set label 1 sprintf('$\chi^2_{\mathrm{red}} = %.4f$',FIT_WSSR/FIT_NDF) at graph 0.02, 0.80

set term push
set term epslatex color 10
set out sprintf('%s.tex',file)

plot f(0,x) title "q=0" lt 1 lc 1, \
f(1,x) title "q=1" lt 1 lc 2, \
f(2,x) title "q=2" lt 1 lc 3, \
f(3,x) title "q=3" lt 1 lc 4, \
f(4,x) title "q=4" lt 1 lc 5

unset out
set term pop