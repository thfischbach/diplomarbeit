clear
reset
file = "finesse_messung_b"
datafile = sprintf('../dat/%s.dat',file)

#set key inside top left
set xlabel 'Zeit t [ms]'
#set format x "%.0f"
set ylabel 'Amplitude U [V]' 2,0
set samples 100000
set xrange [-2:5]
set yrange [-0.1:0.75]
set ytics 0.2
set tmargin 0.1
set rmargin 0.5

set fit errorvariables
f(nu)=d/(1+k*sin(a*nu+b)**2)+c
f1(nu)=-d*(2*a*k*cos(a*nu+b)*sin(a*nu+b)/(1+k*sin(a*nu+b)**2)**2)+c


k = 100
#a = 562
a = 500 
b = 0.430794736078
c = 1
d = 1
fit [-0.002:0.005] f(x) datafile using 1:2 via k, c, d, a
#fit f1(x) datafile using 1:2 via k,a,b,c,d

#latex
#set label 1 '\small $U(t,\kappa,a,b,c) = b\cdot\frac{1}{1+\kappa \sin^2{(at)}}+c$' at graph 0.25, 0.80
set label 2 sprintf('\tiny$\kappa = %.1f\pm%.1f$',k,k_err) at graph 0.25, 0.60
set label 3 sprintf('\tiny$a = (%.3f\pm%.3f)\,$s$^{-1}$',a,a_err) at graph 0.25, 0.50
set label 4 sprintf('\tiny$b = (%.4f\pm%.4f)\,$V',d,d_err) at graph 0.25, 0.40
set label 5 sprintf('\tiny$c = (%.5f\pm%.5f)\,$V',c,c_err) at graph 0.25, 0.30

#picture
#set label 2 sprintf('chi^2 = %.4f',FIT_WSSR/FIT_NDF) at graph 0.02, 0.73
#set label 3 sprintf('k = %.3f +- %.3f',k,k_err) at graph 0.02, 0.66
#set label 4 sprintf('a = %.3f +- %.3f',a,a_err) at graph 0.02, 0.59

#set term windows
set term push
set term epslatex color 10 size 7cm,5cm
set out sprintf('%s.tex',file)

plot datafile using ($1*1000):2 title 'Fringepattern', \
f(x/1000) title 'Fit' lc 2 lt 1

unset out

