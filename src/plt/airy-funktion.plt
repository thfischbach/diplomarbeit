clear
reset
file="airy-funktion"
set key inside top left spacing 1.5
set samples 100000
set xtics nomirror
set ytics nomirror

R(F) = (2*F**2 + pi**2 - pi*sqrt(4*F**2 + pi**2))/(2*F**2)
k(F) = 4*R(F)/(1-R(F))**2
f(F,p) = 1/(1+k(F)*sin(p*pi)**2)

F1 = 2
F2 = 10
F3 = 100

#set label 1 sprintf('$\chi^2_{\mathrm{red}} = %.4f$',FIT_WSSR/FIT_NDF) at graph 0.02, 0.80

set term push
set term epslatex color 10
set out sprintf('%s.tex',file)

set multiplot

set arrow 1 heads from 0,1.05 to 1,1.05
set label 1 'FSR' at 0.4,1.12

set origin 0,0
set size 1,1
set xrange [-0.2:3.2]
set x2tics ("-300" -1, "0" 0, "300" 1, "600" 2, "900" 3)
set yrange [-0.1:1.9]
set ytics ("0" 0, "0.5" 0.5, "1" 1)
set xlabel 'Phase $\nicefrac{\phi}{\pi}$'
set x2label 'Frequenz $\nu$ [MHz]' 0,0
set ylabel 'Transmission' 2,-4
plot f(F1,x) title sprintf('$F=%d$',F1) lt 1 lc 1,\
f(F2,x) title sprintf('$F=%d$',F2) lt 1 lc 2,\
f(F3,x) title sprintf('$F=%d$',F3) lt 1 lc 3


F(R) = pi*sqrt(R)/(1-R)

unset arrow 1
unset label 1

set origin 0.43,0.54
set size 0.55,0.36
set xrange [0:1]
set yrange [-40:150]
unset x2tics
unset x2label
set ytics 50
#set logscale y
set xlabel 'Reflektivit{"a}t' 0,3.3
set ylabel 'Finesse' 2.5,0

set obj 1 circle fc lt 1 at R(F1),F1
set obj 2 circle fc lt 2 at R(F2),F2
set obj 3 circle fc lt 3 at R(F3),F3

plot F(x) notitle lt 1 lc 7

unset multiplot

unset out
set term pop