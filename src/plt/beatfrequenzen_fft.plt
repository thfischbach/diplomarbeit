clear
reset
file = "beatfrequenzen_fft"
datafile = sprintf('../dat/%s.dat',file)

set key inside top right spacing 1
set xlabel 'Frequenz [MHz]'
#set format x "%.0f"
set ylabel 'Amplitude'
set samples 100000
set tmargin 0.1
unset ytics
set lmargin 8

mu = 28
offsetY = -90
n = 10
sigma = 0.5
A = (-40 - offsetY)*(sigma*sqrt(2*pi))
peak(x) = A*exp(-(x-mu)**2/(2*sigma**2))/(sigma*sqrt(2*pi)) - offsetY
set fit errorvariables
fit [mu-n*sigma:mu+n*sigma] peak(x) datafile using 1:2 via A, sigma, mu, offsetY

set label 1 sprintf('$\sigma = (%.3f\pm%.3f)\,$MHz',sigma,sigma_err) at graph 0.1, 0.9
set label 3 sprintf('$\mu = (%.3f\pm%.3f)\,$MHz',mu,mu_err) at graph 0.1, 0.83

n = 5

set term push
set term epslatex color 10 size 14cm, 7cm
set out sprintf('%s.tex',file)

plot datafile using 1:2 with points title 'Messpunkte',\
abs(x-mu) > n*sigma ? 0/0 : peak(x) lc rgb 'green' lt 1 title 'Fit'

unset out