clear
reset
file = "linienscans_neues_schema_01_fake_AI_krass_mean"
datafile = sprintf('../dat/%s.dat',file)

set key inside top right
set xlabel 'Frequenz [THz]'
set ylabel 'Countrate [s$^{-1}$]'
set samples 100000
set mxtics 10
set tmargin 0.2
set format x "%.6f"
#set yrange [1000:6000]

set xrange [385.263060:385.263325]
set xtics 385.263060,0.000050,385.263250

#a = 34.1056
#b = 2210.6994
#sigma_g = 0.00986523/2
#mu = 387.8957

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

gauss(x) = exp(-(x-mu)**2/(2*sigma_g**2))/(sigma_g*sqrt(2*pi))
gauss_fit(x) = a*gauss(x) + b

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

#a = 20
#b = 2210.6994
#q = 10
#gamma = 0.00986523
#E0 = 387.8957

#fano(x) = (q*gamma/2+x-E0)**2/((x-E0)**2+(gamma/2)**2)
#fano_fit(x) = a * fano(x) + b


#fit voigt_fit(x) datafile using 1:2 via a,c,sigma,s,mu,n
#fit voigt_b_fit(x) datafile using 1:2 via a,b,sigma,sigma_g,s,mu,n
#fit gauss_fit(x) datafile using 1:2 via a,b,sigma_g,mu
#fit lorentz_b_fit(x) datafile using 1:2 via a,b,sigma,mu,s
#fit lorentz_fit(x) datafile using 1:2 via a,b,sigma,mu
#fit test(x) datafile using 1:2 via a,b,sigma,mu,s,n
#fit fano_fit(x) datafile using 1:2 via a,b,gamma,E0

############################
# mit QTI-Plot Gefittet!!! #
############################
#A (Fläche) = 3.1212172321868e-01 +/- 6.5744250686679e-03
#xc (Mitte) = 3.8526314326832e+02 +/- 2.1359821997894e-07
#w (Breite) = 2.8653776285065e-05 +/- 5.3666304045728e-07
#y0 (Offset) = 5.4280452850529e+02 +/- 6.5567330410274e+01

a = 0.3121
da = 0.0066
mu = 385.26314326
dmu = 0.00000021
sigma2_g = 28.65
dsigma2_g = 0.54
sigma_g = sigma2_g/2/1000000
dsigma_g = dsigma2_g/2/1000000
b = 543
db = 66

labelx_offset = 0.45
labely_offset = 0.3

set label 1 '$G(\nu)=A\cdot\frac{1}{\sigma\sqrt{2\pi}}\mathrm{e}^{-\frac{1}{2}\frac{(\nu-\mu)^2}{\sigma^2}}+b$' at graph labelx_offset, labely_offset + 0.36
set label 2 sprintf('$2\sigma = (%.2f\pm%.2f)\,$MHz',sigma2_g,dsigma2_g) at graph labelx_offset, labely_offset + 0.21
set label 3 sprintf('$\mu = (%.8f\pm%.8f)\,$THz',mu,dmu) at graph labelx_offset, labely_offset + 0.14
set label 4 sprintf('$A = (%.4f\pm%.4f)\,\nicefrac{\text{MHz}}{\text{s}}$',a,da) at graph labelx_offset, labely_offset + 0.07
set label 5 sprintf('$b = (%.0f\pm%.0f)\,$s$^{-1}$',b,db) at graph labelx_offset, labely_offset

set term push
set term epslatex color 10 size 14cm, 7cm
set out sprintf('%s.tex',file)

plot datafile using 1:2 with points title 'Messpunkte' lc rgb '#CC0033',\
(385.263067<x && x<385.263223)? gauss_fit(x):1/0 lc rgb 'red' lt 1 title 'Fit'

unset out