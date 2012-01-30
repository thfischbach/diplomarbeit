clear
reset
file = "linienscans_neues_schema_02_AI_03_mean"
datafile = sprintf('../dat/%s.dat',file)

set key inside top right
set xlabel 'Frequenz [THz]'
set ylabel 'Countrate [s$^{-1}$]'
set samples 100000
set mxtics 10
set tmargin 0.2
#set logscale y

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
FIT_LIMIT=1e-5

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
a2 = 4
#a3 = 1

q1 = 12.
q2 = 22.
#q3 = 12.

gamma1 = 0.00124
gamma2 = 0.00366
#gamma3 = 0.002

E1 = 379.525
E2 = 379.529
#E3 = 381.138

EOffset = 379.0

E1 = E1 - EOffset
E2 = E2 - EOffset
#E3 = E3 - EOffset

b = 0

fano1(x) = (q1*gamma1/2.0+x-E1)**2/((x-E1)**2+(gamma1/2.0)**2)
fano2(x) = (q2*gamma2/2.0+x-E2)**2/((x-E2)**2+(gamma2/2.0)**2)
fano3(x) = (q3*gamma3/2.0+x-E3)**2/((x-E3)**2+(gamma3/2.0)**2)

#fano1_fit(x) = a1 * fano1(x) + b
#fano2_fit(x) = a1 * fano1(x) + a2 * fano2(x) + b
#fano3_fit(x) = a1 * fano1(x) + a2 * fano2(x) + a3 * fano3(x) + b

fano1_fit(x) = fano1(x)
fano2_fit(x) = fano1(x) + fano2(x)
fano3_fit(x) = fano1(x) + fano2(x) + fano3(x)


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


#gamma1 = tan((0.0013-0)*pi/(1-0)-pi/2)
#gamma2 = tan((0.0012-0)*pi/(1-0)-pi/2)
#gamma3 = tan((0.0022-0)*pi/(1-0)-pi/2)

#gamma1 = 0.00106
#gamma2 = 0.000905
#gamma3 = 0.00228

#E1 = 383.122261
#E2 = 383.124301
#E3 = 383.138340

#q1 = 25.0
#q2 = 30.0
#q3 = 12.0

#a1 = 1.0
#a2 = 1.0
#a3 = 1.0



#fit voigt_fit(x) datafile using 1:2 via a,c,sigma,s,mu,n
#fit voigt_b_fit(x) datafile using 1:2 via a,b,sigma,sigma_g,s,mu,n
#fit gauss_fit(x) datafile using 1:2 via a,b,sigma,mu
#fit lorentz_b_fit(x) datafile using 1:2 via a,b,sigma,mu,s
#fit lorentz_fit(x) datafile using 1:2 via a,b,sigma,mu
#fit test(x) datafile using 1:2 via a,b,sigma,mu,s,n
#fit [381.816:381.824] fano1_fit(x) datafile using 1:2 via gamma1
fit fano2_fit(x) datafile using ($1-EOffset):2 via gamma1,gamma2,q1,q2,E1,E2
#fit fano3_fit(x) datafile using ($1-EOffset):2 via gamma1,gamma2,gamma3,q1,q2,q3,E1,E2,E3
#fit kmatrix2(x) datafile using 1:2 via a2,gamma1,gamma2,q1,q2,E1,E2
#fit kmatrix3(x) datafile using 1:2 via gamma1,gamma2,gamma3,q1,q2,q3,E1,E2,E3
#pr Gamma1(gamma1), Gamma2(gamma2), Gamma3(gamma3)

#fit [383.1205:383.123] fano1(x) datafile using 1:2 via gamma1,q1,E1
#fit [383.1235:383.128] fano2(x) datafile using 1:2 via gamma2,q2,E2
#fit [383.134:383.144] fano3(x) datafile using 1:2 via gamma3,q3,E3

set label 1 '$F_{\text{sum}}=\sum\limits_{k=1}^2\frac{\left(\nicefrac{q_k\Gamma_k}{2}+\nu-\nu_k\right)^2}{(\nu-\nu_k)^2+\left(\nicefrac{\Gamma_k}{2}\right)^2}$' at graph 0.5, 0.70
set label 2 sprintf('$\Gamma_1 = (%.3f\pm%.3f)\,$GHz',gamma1*1000,gamma1_err*1000) at graph 0.5, 0.53
set label 3 sprintf('$\nu_1 = (%.6f\pm%.6f)\,$THz',E1+EOffset,E1_err) at graph 0.5, 0.46
set label 4 sprintf('$q_1 = %.2f\pm%.2f$',q1,q1_err) at graph 0.5, 0.39
set label 5 sprintf('$\Gamma_2 = (%.1f\pm%.1f)\,$GHz',gamma2*1000,gamma2_err*1000) at graph 0.5, 0.32
set label 6 sprintf('$\nu_2 = (%.5f\pm%.5f)\,$THz',E2+EOffset,E2_err) at graph 0.5, 0.25
set label 7 sprintf('$q_2 = %.1f\pm%.1f$',q2,q2_err) at graph 0.5, 0.18

E1 = E1 + EOffset
E2 = E2 + EOffset
#E3 = E3 + EOffset

set term push
set term epslatex color 10 size 14cm, 7cm
set out sprintf('%s.tex',file)

plot datafile using 1:2 with points title 'Messpunkte' lc rgb '#CC0033',\
fano2_fit(x) lc rgb 'blue' lt 1 lw 2 title 'Fit'

unset out