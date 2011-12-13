clear
reset
file="haensch-couillaud_fehlersignal"
set key inside top right
set xlabel 'Phasenverschiebung relativ zur Resonanz $\nicefrac{\delta}{\pi}$'
set ylabel 'Amplitude'
set samples 100000
set xrange [-3:3]
set yrange [-1.3:1.3]
set xtics
set ytics

f(d,r,th,t1) = cos(th)*sin(th)*(t1**2*r**2*sin(d*pi))/((1 - r**2)**2 + 4*r**2*sin(d*pi/2)**2)

set object 1 rect from -1,0.1 to 1,-0.1
#set label 1 sprintf('$\chi^2_{\mathrm{red}} = %.4f$',FIT_WSSR/FIT_NDF) at graph 0.02, 0.80

set term push
set term epslatex color 10
set out sprintf('%s.tex',file)

plot 0 notitle lt 1 lc rgb "light-gray",\
f(x,0.85,1,1) notitle lt 1 lc 1

unset out
set term pop