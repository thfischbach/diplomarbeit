clear
reset
file = "linienscans_altes_schema_AI"
datafile = sprintf('../dat/%s.dat',file)

set key inside top right
set xlabel 'Relativfrequenz [MHz]'
set ylabel 'Countrate [s$^{-1}$]'
set samples 100000
set mxtics 10
set tmargin 0.2

set xrange [-300:300]

#a = 150000
#b = 1
#sigma = 50
#mu = 1

#a = 150000
#b = 1
#sigma = 0.01
#sigma_g = 100
#s = 10
#n = 0.5

set fit errorvariables
#FIT_LIMIT=1e-12

#gauss(x) = exp(-(x-mu)**2/(2*sigma_g**2))/(sigma_g*sqrt(2*pi))
#gauss_fit(x) = a*gauss(x) + b

#lorentz(x)= sigma/(2*pi)/(sigma**2+4*(x-mu)**2)
#lorentz_fit(x) = a * lorentz(x) + b

#lorentz_b(x)= sigma*s/(2*(s+1)*(1+4*(x-mu)**2/(1+s)*sigma**2))
#lorentz_b_fit(x) = a * lorentz_b(x) + b

#voigt(x)= (n*lorentz(x)+(1-n)*gauss(x))
#voigt_fit(x) = a * voigt(x) + b

#voigt_b(x)= (n*lorentz_b(x)+(1-n)*gauss(x))
#voigt_b_fit(x) = a * voigt_b(x) + b

#test(x) = a * s*voigt(x)/(1+s*voigt(x)) + b



#################
##### Fano ######
#################

a = 0.11
b = 0.69
q = 60
gamma = 55.8
E0 = -3.3

fano(x) = (q*gamma/2+x-E0)**2/((x-E0)**2+(gamma/2)**2)
fano_fit(x) = a * fano(x) + b


#fit voigt_fit(x) datafile using 1:2 via a,c,sigma,s,mu,n
#fit voigt_b_fit(x) datafile using 1:2 via a,b,sigma,sigma_g,s,mu,n
#fit gauss_fit(x) datafile using 1:2 via a,b,sigma,mu
#fit lorentz_b_fit(x) datafile using 1:2 via a,b,sigma,mu,s
#fit lorentz_fit(x) datafile using 1:2 via a,b,sigma,mu
#fit test(x) datafile using 1:2 via a,b,sigma,mu,s,n
fit fano_fit(x) datafile using 1:2 via a,b,gamma,q,E0

set label 1 '$F(\nu)=a\cdot\frac{\left(\nicefrac{q\Gamma}{2}+\nu-\nu_0\right)^2}{\left(\nu-\nu_0\right)^2+\left(\nicefrac{\Gamma}{2}\right)^2}+b$' at graph 0.05, 0.90
set label 2 sprintf('$\Gamma = (%.1f\pm%.1f)\,$MHz',gamma,gamma_err) at graph 0.05, 0.75
set label 3 sprintf('$\nu_0 = (%.2f\pm%.2f)\,$MHz',E0,E0_err) at graph 0.05, 0.68
set label 4 sprintf('$q = %.0f\pm%.0f$',q,q_err) at graph 0.05, 0.61
set label 5 sprintf('$a = (%.3f\pm%.3f)\,$s$^{-1}$',a,a_err) at graph 0.05, 0.54
set label 6 sprintf('$b = (%.1f\pm%.1f)\,$s$^{-1}$',b,b_err) at graph 0.05, 0.47

set term push
set term epslatex color 10 size 14cm, 7cm
set out sprintf('%s.tex',file)

plot datafile using 1:2 with points title 'Messpunkte' lc rgb '#CC0033',\
fano_fit(x) lc rgb 'red' lt 1 title 'Fit'

unset out