clear
reset
file = "finesse_messung_c"
datafile = sprintf('../dat/%s.dat',file)

#set key inside top left
set xlabel 'Zeit t [ms]'
#set format x "%.0f"
set ylabel 'Amplitude U [V]'
set samples 100000
set xrange [-3.5:3.5]
set yrange [1:5.5]

set fit errorvariables
f(nu)=d/(1+k*sin(a*nu+b)**2)+c
f1(nu)=-d*(2*a*k*cos(a*nu+b)*sin(a*nu+b)/(1+k*sin(a*nu+b)**2)**2)+c


k = 1
#a = 562
a = 1000 
b = 4.212915738452
c = 1
d = 1
fit [-0.003:0.005] f(x) datafile using 1:2 via k, c, d, a
#fit f1(x) datafile using 1:2 via k,a,b,c,d

#latex
#set label 1 '\small $U(t,\kappa,a,b,c) = b\cdot\frac{1}{1+\kappa \sin^2{(at)}}+c$' at graph 0.25, 0.80
set label 2 sprintf('$\kappa = %.3f\pm%.3f$',k,k_err) at graph 0.25, 0.31
set label 3 sprintf('$a = (%.2f\pm%.2f)\,$s$^{-1}$',a,a_err) at graph 0.25, 0.24
set label 4 sprintf('$b = (%.3f\pm%.3f)\,$V',d,d_err) at graph 0.25, 0.17
set label 5 sprintf('$c = (%.3f\pm%.3f)\,$V',c,c_err) at graph 0.25, 0.10

#picture
#set label 2 sprintf('chi^2 = %.4f',FIT_WSSR/FIT_NDF) at graph 0.02, 0.73
#set label 3 sprintf('k = %.3f +- %.3f',k,k_err) at graph 0.02, 0.66
#set label 4 sprintf('a = %.3f +- %.3f',a,a_err) at graph 0.02, 0.59

#set term windows
set term push
set term epslatex color 10 size 14cm,7cm
set out sprintf('%s.tex',file)

plot datafile using ($1*1000):2 title 'Fringepattern', \
f(x/1000) title 'Fit' lc 2 lt 1

unset out
