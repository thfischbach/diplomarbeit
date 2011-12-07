clear
reset
file="moden_frequenzselektion"
set key inside top right
set xlabel 'Frequenz'
set ylabel 'Verst{"a}rkung'
set samples 100000
set xrange [-30:30]
set yrange [0:5]
unset xtics
unset ytics
set encoding utf8

f(x,a,b,c,d) = a*(cos(b*x+d)+1.0)/2.0+c
g(x,a,b) = -a*x**2+b


p = 0 #Phase

x1 = -0.3
set arrow 1 from -10,3.5 to x1,g(x1,0.0001,1)*f(x1,1.0,0.3,0.5,0)*g(x1,0.0005,1)*f(x1,1.0,2.0,0.3,p)+1.6
set label 1 'anschwingende Mode' at -20,3.7

set term push
set term epslatex color 10
set out sprintf('%s_a.tex',file)

plot g(x,0.0001*1.5,1.5) title 'Verst{"a}rkungs-Profil' lt 1 lc 1, \
g(x,0.0001,1)*f(x,1.0,0.3,0.5,0) title "interne Moden" lt 1 lc 3, \
g(x,0.0005*1.3,1.3) title "Winkeldispersion des Gitters" lt 1 lc 2, \
g(x,0.0005,1)*f(x,1.0,2.0,0.3,p) title "externe Moden" lt 1 lc 4, \
g(x,0.0001,1)*f(x,1.0,0.3,0.5,0)*g(x,0.0005,1)*f(x,1.0,2.0,0.3,p)+1.6 title 'gesamte Verst{"a}rkung' lt 1 lc 5, \
abs(x) > pi/2 ? 0/0 : g(x,0.0001,1)*f(x,1.0,0.3,0.5,0)*g(x,0.0005,1)*f(x,1.0,2.0,0.3,p)+1.6 notitle lt 1 lc 7

unset out
unset arrow 1
unset label 1


p = pi #Phase

x1 = -pi/2
x2 = pi/2
set arrow 1 heads from x1,g(x1,0.0001,1)*f(x1,1.0,0.3,0.5,0)*g(x1,0.0005,1)*f(x1,1.0,2.0,0.3,p)+1.6 to x2,g(x2,0.0001,1)*f(x2,1.0,0.3,0.5,0)*g(x2,0.0005,1)*f(x2,1.0,2.0,0.3,p)+1.6

x1 = -2
set arrow 2 from -10,3.7 to x1,g(x1,0.0001,1)*f(x1,1.0,0.3,0.5,0)*g(x1,0.0005,1)*f(x1,1.0,2.0,0.3,p)+1.6+0.3
set label 1 'Modensprung bzw. Multi-Mode' at -25,3.8

set term push
set term epslatex color 10
set out sprintf('%s_b.tex',file)

plot g(x,0.0001*1.5,1.5) title 'Verst{"a}rkungs-Profil' lt 1 lc 1, \
g(x,0.0001,1)*f(x,1.0,0.3,0.5,0) title "interne Moden" lt 1 lc 3, \
g(x,0.0005*1.3,1.3) title "Winkeldispersion des Gitters" lt 1 lc 2, \
g(x,0.0005,1)*f(x,1.0,2.0,0.3,p) title "externe Moden" lt 1 lc 4, \
g(x,0.0001,1)*f(x,1.0,0.3,0.5,0)*g(x,0.0005,1)*f(x,1.0,2.0,0.3,p)+1.6 title 'gesamte Verst{"a}rkung' lt 1 lc 5, \
abs(x) > pi ? 0/0 : g(x,0.0001,1)*f(x,1.0,0.3,0.5,0)*g(x,0.0005,1)*f(x,1.0,2.0,0.3,p)+1.6 notitle lt 1 lc 7

unset out

set term pop