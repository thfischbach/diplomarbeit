clear
reset
file = "linienscans_neues_schema_01_AI_bsp_mean"
datafile = sprintf('../dat/%s.dat',file)

set key inside top right
set xlabel 'Frequenz [THz]'
set ylabel 'Countrate [s$^{-1}$]'
set samples 100000
set mxtics 10
set tmargin 0.2
set format x "%.3f"
set yrange [1000:6000]

#set xrange [-300:300]
set xtics 0.004

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
#A (Fläche) = 3.8476153897616e+01 +/- 4.0135372352252e+00
#xc (Mitte) = 3.8789559212906e+02 +/- 6.8252695340009e-05
#w (Breite) = 1.0589213470442e-02 +/- 5.4112659641093e-04
#y0 (Offset) = 2.0391620082333e+03 +/- 1.6775369619511e+02

a = 38.5
da = 4.0
mu = 387.895592
dmu = 0.000068
sigma2_g = 10.59
dsigma2_g = 0.54
sigma_g = sigma2_g/2/1000
dsigma_g = dsigma2_g/2/1000
b = 2039
db = 168

set label 1 '$G(\nu)=A\cdot\frac{1}{\sigma\sqrt{2\pi}}\mathrm{e}^{-\frac{1}{2}\frac{(\nu-\mu)^2}{\sigma^2}}+b$' at graph 0.35, 0.45
set label 2 sprintf('$2\sigma = (%.2f\pm%.2f)\,$GHz',sigma2_g,dsigma2_g) at graph 0.35, 0.30
set label 3 sprintf('$\mu = (%.6f\pm%.6f)\,$THz',mu,dmu) at graph 0.35, 0.23
set label 4 sprintf('$A = (%.1f\pm%.1f)\,\nicefrac{\text{MHz}}{\text{s}}$',a,da) at graph 0.35, 0.16
set label 5 sprintf('$b = (%.0f\pm%.0f)\,$s$^{-1}$',b,db) at graph 0.35, 0.09

set term push
set term epslatex color 10 size 14cm, 7cm
set out sprintf('%s.tex',file)

plot datafile using 1:2 with points title 'Messpunkte' lc rgb '#CC0033',\
gauss_fit(x) lc rgb 'red' lt 1 title 'Fit'

unset out