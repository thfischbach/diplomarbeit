clear
reset
file="pound-drever-hall_fehlersignal"
set key inside top right
set xlabel 'Verstimmung zur Resonanz $\Delta\omega$'
set ylabel '$A(\Delta\omega)$'
set samples 100000
set xrange [-10:10]
set yrange [-0.5:0.5]
set xtics
set ytics
f(dw,g,wm) = -4*(wm*(g/2)*dw*((g/2)**2-dw**2+wm**2))/(((g/2)**2+dw**2)*((g/2)**2+(dw+wm)**2)*((g/2)**2+(dw-wm)**2))
wm = 5

#set object 1 rect from -wm,0.02 to wm,-0.02
#set label 1 sprintf('$\chi^2_{\mathrm{red}} = %.4f$',FIT_WSSR/FIT_NDF) at graph 0.02, 0.80

set term push
set term epslatex color 10
set out sprintf('%s.tex',file)

plot 0 notitle lt 1 lc rgb "light-gray",\
f(x,0.4,wm) notitle lt 1 lc 1

unset out
set term pop