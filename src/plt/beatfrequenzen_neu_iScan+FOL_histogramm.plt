clear
reset
file = "beatfrequenzen_neu_iScan+FOL_histogramm"
datafile = sprintf('../dat/%s.dat',file)
unset key
set xlabel 'Schwebungsfrequenz [MHz]'
set ylabel 'H"aufigkeit'
set yrange [0:160]
set xrange [5:35]

set style histogram cluster gap 1
set style fill solid border -1

binwidth=0.627307692308
set boxwidth binwidth

A = 100
sigma = 5
mu = 10

set fit errorvariables
gauss(x) = A*exp(-(x-mu)**2/(2*sigma**2))/(sigma*sqrt(2*pi))
fit gauss(x) datafile using 1:2 via sigma,mu,A

set label 1 sprintf('$2\sigma = (%.2f\pm%.2f)\,$MHz',2*sigma,2*sigma_err) at graph 0.05, 0.95
set label 2 sprintf('$A = (%.0f\pm%.0f)\,$MHz',A,A_err) at graph 0.05, 0.88
set label 3 sprintf('$\mu = (%.3f\pm%.3f)\,$MHz',mu,mu_err) at graph 0.05, 0.81


set term push
set term epslatex color 10
set out sprintf('%s.tex',file)

plot datafile using 1:2 smooth freq with boxes,\
gauss(x) title 'Fit' lc 3 lt 1
unset out