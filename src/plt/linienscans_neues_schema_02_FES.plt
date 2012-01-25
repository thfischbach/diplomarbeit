clear
reset
file = "linienscans_neues_schema_02_FES"
datafile = sprintf('../dat/%s.dat',file)

set key inside top right
set xlabel 'Relativfrequenz [MHz]'
set ylabel 'Countrate [s$^{-1}$]'
set samples 100000
set mxtics 10
set tmargin 0.2
#set format x "%.3f"

#set xrange [-300:300]
#set xtics 0.004

a = 88000
b = 1
mu = -5.2

a_g = 30000
sigma_g = 20

a_l = 1000
gamma_l = 0.5

s = 50000

n = 1

set fit errorvariables
#FIT_LIMIT=1e-12

gauss(x) = exp(-(x-mu)**2/(2*sigma_g**2))/(sigma_g*sqrt(2*pi))
gauss_fit(x) = a * gauss(x) + b

lorentz(x)= gamma_l/(2*pi)/(gamma_l**2+4*(x-mu)**2)
lorentz_fit(x) = a * lorentz(x) + b

lorentz_b(x)= gamma_l*s/(2*(s+1)*(1+4*(x-mu)**2/((1+s)*gamma_l**2)))
lorentz_b_fit(x) = a * lorentz_b(x) + b

#voigt(x)= (n*lorentz(x)+(1-n)*gauss(x))
#voigt_fit(x) = a * voigt(x) + b

voigt_b(x)= (n*a_l*lorentz_b(x)+(1-n)*a_g*gauss(x))
voigt_b_fit(x) = a * voigt_b(x) + b

#test(x) = a * s*voigt(x)/(1+s*voigt(x)) + b



#################
##### Fano ######
#################

#a = 0.11
#b = 0.69
#q = 60
#gamma = 55.8
#E0 = -3.3

#fano(x) = (q*gamma/2+x-E0)**2/((x-E0)**2+(gamma/2)**2)
#fano_fit(x) = a * fano(x) + b


#fit voigt_fit(x) datafile using 1:2 via a,c,sigma,s,mu,n
#fit voigt_b_fit(x) datafile using 1:2 via a,b,a_g,a_l,sigma_g,gamma_l,s,mu,n
fit gauss_fit(x) datafile using ($1*1000000):4 via a,b,sigma_g,mu
#fit lorentz_b_fit(x) datafile using 1:2 via a,b,sigma,mu,s
#fit lorentz_fit(x) datafile using ($1*1000000):2 via a,b,gamma,mu
#fit test(x) datafile using 1:2 via a,b,sigma,mu,s,n
#fit fano_fit(x) datafile using 1:2 via a,b,gamma,q,E0

set label 1 '$G(\nu)=A\cdot\frac{1}{\sigma\sqrt{2\pi}}\mathrm{e}^{-\frac{1}{2}\frac{(\nu-\mu)^2}{\sigma^2}}+b$' at graph 0.03, 0.9
set label 2 sprintf('$2\sigma = (%.2f\pm%.2f)\,$MHz',2*sigma_g,2*sigma_g_err) at graph 0.03, 0.75
set label 3 sprintf('$\mu = (%.2f\pm%.2f)\,$MHz',mu,mu_err) at graph 0.03, 0.68
set label 4 sprintf('$A = (%.0f\pm%.0f)\,\nicefrac{\text{MHz}}{\text{s}}$',a,a_err) at graph 0.03, 0.61
set label 5 sprintf('$b = (%.1f\pm%.1f)\,$s$^{-1}$',b,b_err) at graph 0.03, 0.54

set term push
set term epslatex color 10 size 14cm, 7cm
set out sprintf('%s.tex',file)

plot datafile using ($1*1000000):4 with points title 'Messpunkte' lc rgb 'blue',\
gauss_fit(x) lc rgb '#00BFFF' lt 1 title 'Fit'

unset out