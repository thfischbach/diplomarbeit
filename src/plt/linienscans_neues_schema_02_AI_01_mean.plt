clear
reset
file = "linienscans_neues_schema_02_AI_01_mean"
datafile = sprintf('../dat/%s.dat',file)

set key inside top right
set xlabel 'Relativfrequenz [MHz]'
set ylabel 'Countrate [s$^{-1}$]'
set samples 100000
set mxtics 10
set tmargin 0.2

#set xrange [-300:300]

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

a1 = 1
a2 = 1
a3 = 1

q1 = 47
q2 = 12
q3 = 60
gamma1 = 0.0012
gamma2 = 0.002
gamma3 = 55.8
E01 = 381.8187421
E02 = 381.8267
E03 = -3.3

b = 0.69

fano1(x) = (q1*gamma1/2+x-E01)**2/((x-E01)**2+(gamma1/2)**2)
fano2(x) = (q2*gamma2/2+x-E02)**2/((x-E02)**2+(gamma2/2)**2)
fano3(x) = (q3*gamma3/2+x-E03)**2/((x-E03)**2+(gamma3/2)**2)

#fano1_fit(x) = a1 * fano1(x) + b
#fano2_fit(x) = a1 * fano1(x) + a2 * fano2(x) + b
#fano3_fit(x) = a1 * fano1(x) + a2 * fano2(x) + a3 * fano3(x) + b

fano1_fit(x) = fano1(x) + b
fano2_fit(x) = fano1(x) + fano2(x) + b
fano3_fit(x) = fano1(x) + fano2(x) + fano3(x) + b


#################
#### K-Matrix####
#################

# Restrict gamma1 to the range of [0:1]
Gamma1(x) = (1-0)/pi*(atan(x)+pi/2)+0

# Restrict gamma2 to the range of [0:1]
Gamma2(x) = (1-0)/pi*(atan(x)+pi/2)+0

# Restrict gamma3 to the range of [0:1]
Gamma3(x) = (1-0)/pi*(atan(x)+pi/2)+0


#mit Einschränkungem
#zaehler_summe1(x) = Gamma1(gamma1)*q1/(2*(E1-x))
#zaehler_summe2(x) = Gamma2(gamma2)*q2/(2*(E2-x))
#zaehler_summe3(x) = Gamma3(gamma3)*q3/(2*(E3-x))

#nenner_summe1(x) = Gamma1(gamma1)/(2*(E1-x))
#nenner_summe2(x) = Gamma2(gamma2)/(2*(E2-x))
#nenner_summe3(x) = Gamma3(gamma3)/(2*(E3-x))


#ohne Einschränkungen
zaehler_summe1(x) = gamma1*q1/(2*(E1-x))
zaehler_summe2(x) = gamma2*q2/(2*(E2-x))
zaehler_summe3(x) = gamma3*q3/(2*(E3-x))

nenner_summe1(x) = gamma1/(2*(E1-x))
nenner_summe2(x) = gamma2/(2*(E2-x))
nenner_summe3(x) = gamma3/(2*(E3-x))


zaehler1(x) = (1 + zaehler_summe1(x))**2
zaehler2(x) = (1 + zaehler_summe1(x) + zaehler_summe2(x))**2
zaehler3(x) = (1 + zaehler_summe1(x) + zaehler_summe2(x) + zaehler_summe3(x))**2

nenner1(x) = 1 + (nenner_summe1(x))**2
nenner2(x) = 1 + (nenner_summe1(x) + nenner_summe2(x))**2
nenner3(x) = 1 + (nenner_summe1(x) + nenner_summe2(x) + nenner_summe3(x))**2

kmatrix1(x) = a1*zaehler1(x)/nenner1(x)
kmatrix2(x) = a2*zaehler2(x)/nenner2(x)
kmatrix3(x) = a3*zaehler3(x)/nenner3(x)


gamma1 = 0.0012
gamma2 = 0.0012
gamma3 = 1

E1 = 381.8187421
E2 = 381.8270381
E3 = 1

q1 = 20
q2 = 12
q3 = 1

a1 = 1
a2 = 1
a3 = 1



#fit voigt_fit(x) datafile using 1:2 via a,c,sigma,s,mu,n
#fit voigt_b_fit(x) datafile using 1:2 via a,b,sigma,sigma_g,s,mu,n
#fit gauss_fit(x) datafile using 1:2 via a,b,sigma,mu
#fit lorentz_b_fit(x) datafile using 1:2 via a,b,sigma,mu,s
#fit lorentz_fit(x) datafile using 1:2 via a,b,sigma,mu
#fit test(x) datafile using 1:2 via a,b,sigma,mu,s,n
#fit fano_fit(x) datafile using 1:2 via a1,b,gamma,q,E0
#fit fano2_fit(x) datafile using 1:2 via a1,a2,b,gamma1,gamma2,q1,q2,E01,E02
#fit fano2_fit(x) datafile using 1:2 via b,gamma1,gamma2,q1,q2,E01,E02
fit kmatrix2(x) datafile using 1:2 via a2,gamma1,gamma2,q1,q2,E2
pr Gamma1(gamma1), Gamma2(gamma2), Gamma3(gamma3)

#set label 1 '$F(\nu)=a\cdot\frac{\left(\nicefrac{q\Gamma}{2}+\nu-\nu_0\right)^2}{\left(\nu-\nu_0\right)^2+\left(\nicefrac{\Gamma}{2}\right)^2}+b$' at graph 0.05, 0.90
#set label 2 sprintf('$\Gamma = (%.1f\pm%.1f)\,$MHz',gamma,gamma_err) at graph 0.05, 0.75
#set label 3 sprintf('$\nu_0 = (%.2f\pm%.2f)\,$MHz',E0,E0_err) at graph 0.05, 0.68
#set label 4 sprintf('$q = %.0f\pm%.0f$',q,q_err) at graph 0.05, 0.61
#set label 5 sprintf('$a = (%.3f\pm%.3f)\,$s$^{-1}$',a,a_err) at graph 0.05, 0.54
#set label 6 sprintf('$b = (%.1f\pm%.1f)\,$s$^{-1}$',b,b_err) at graph 0.05, 0.47

set term push
set term epslatex color 10 size 14cm, 7cm
set out sprintf('%s.tex',file)

plot datafile using 1:2 with points title 'Messpunkte' lc rgb '#CC0033',\
kmatrix2(x) lc rgb 'red' lt 1 title 'Fit'

unset out