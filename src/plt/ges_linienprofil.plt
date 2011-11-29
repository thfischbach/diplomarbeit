clear
reset
file="ges_linienprofil"
set key inside top left spacing 1.2
set xlabel 'E'
set ylabel '$\sigma$'
set samples 100000
set xrange [-10:30]
#set yrange [5:15]

g(w,w0) = exp(-((w-w0)/w0)**2)
ld(w,w1,w0,g) = g(w1,w0)*(g/2)**2/((w-w1)**2+(g/2)**2)
l(w,w0,g) = (g/2)**2/((w-w0)**2+(g/2)**2)
v(w,w0,g,n) = n*l(w,w0,g) + (1-n)*g(w,w0)


#set label 1 sprintf('$\chi^2_{\mathrm{red}} = %.4f$',FIT_WSSR/FIT_NDF) at graph 0.02, 0.80

set term push
set term epslatex color
set out sprintf('%s.tex',file)

plot g(x,10.0) title "Doppler-Profil" lt 3 lc 2, \
ld(x,0.0,10.0,2.0) title "Doppler-Klassen (Loretz-Profil)" lt 2 lc 5, \
ld(x,5.0,10.0,2.0) notitle lt 2 lc 5, \
ld(x,10.0,10.0,2.0) notitle lt 2 lc 5, \
ld(x,15.0,10.0,2.0) notitle lt 2 lc 5, \
ld(x,20.0,10.0,2.0) notitle lt 2 lc 5, \
v(x,10.0,2.0,0.01) notitle lt 1 lc 1

unset out
set term pop