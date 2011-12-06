clear
reset
file="moden_frequenzselektion"
set key inside top right
set xlabel 'Verstaerkung'
set ylabel 'Frequenz'
set samples 100000
set xrange [-30:30]
set yrange [0:5]
unset xtics
unset ytics
set encoding utf8

f(x,a,b,c) = a*(cos(b*x)+1.0)/2.0+c
g(x,a,b) = -a*x**2+b


set arrow from -10,3.5 to -0.3,g(-0.3,0.0001,1)*f(-0.3,1.0,0.3,0.5)*g(-0.3,0.0005,1)*f(-0.3,1.0,2.0,0.3)+1.6
set label 1 'anschwingende Mode' at -20,3.7

set term push
set term epslatex color 10
set out sprintf('%s.tex',file)

plot g(x,0.0001*1.5,1.5) title "Verstaerkungs-Profil" lt 1 lc 1, \
g(x,0.0001,1)*f(x,1.0,0.3,0.5) title "interne Moden" lt 1 lc 3, \
g(x,0.0005*1.3,1.3) title "Winkeldispersion des Gitters" lt 1 lc 2, \
g(x,0.0005,1)*f(x,1.0,2.0,0.3) title "externe Moden" lt 1 lc 4, \
g(x,0.0001,1)*f(x,1.0,0.3,0.5)*g(x,0.0005,1)*f(x,1.0,2.0,0.3)+1.6 title "gesamte Verstaerkung" lt 1 lc 5, \
abs(x) > 1.5 ? 0/0 : g(x,0.0001,1)*f(x,1.0,0.3,0.5)*g(x,0.0005,1)*f(x,1.0,2.0,0.3)+1.6 notitle lt 1 lc 7

unset out
set term pop