clear
reset
file = "linienscans_altes_schema_FES"
datafile = sprintf('../dat/%s.dat',file)

set key inside top right
set xlabel 'Relativfrequenz [MHz]'
set ylabel 'Countrate [s$^{-1}$]'
set samples 100000
set mxtics 10
set tmargin 0.2

set xrange [-150:150]

A = 10000
sigma = 19
mu = 1
b = 1

set fit errorvariables
gauss(x) = A*exp(-(x-mu)**2/(2*sigma**2))/(sigma*sqrt(2*pi))+b
fit gauss(x) datafile using 1:2 via sigma,mu,A,b

set label 1 '$G(\nu)=A\cdot\frac{1}{\sigma\sqrt{2\pi}}\mathrm{e}^{-\frac{1}{2}\frac{(\nu-\mu)^2}{\sigma^2}}+b$' at graph 0.03, 0.9
set label 2 sprintf('$2\sigma = (%.2f\pm%.2f)\,$MHz',2*sigma,2*sigma_err) at graph 0.03, 0.75
set label 3 sprintf('$\mu = (%.2f\pm%.2f)\,$MHz',mu,mu_err) at graph 0.03, 0.68
set label 4 sprintf('$A = (%.0f\pm%.0f)\,\nicefrac{\text{MHz}}{\text{s}}$',A,A_err) at graph 0.03, 0.61
set label 5 sprintf('$b = (%.1f\pm%.1f)\,$s$^{-1}$',b,b_err) at graph 0.03, 0.54

set term push
set term epslatex color 10 size 14cm, 7cm
set out sprintf('%s.tex',file)

plot datafile using 1:2 with points title 'Messpunkte' lc rgb 'blue',\
gauss(x) lc rgb '#00BFFF' lt 1 title 'Fit'

unset out