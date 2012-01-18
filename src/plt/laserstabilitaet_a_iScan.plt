clear
reset
file = "laserstabilitaet_a_iScan"
datafile = sprintf('../dat/%s.dat',file)

starttime = 488506165

set term push
set term epslatex color 10 size 14cm, 7cm
set out sprintf('%s.tex',file)
set multiplot



#set fit errorvariables
#set dummy f
#f(x)=a*x+b
#b=14
#a=0.02
#fit f(x) datafile using 1:2:3 via a,b
#set label 1 sprintf('$\chi^2_{\mathrm{red}} = %.4f$',FIT_WSSR/FIT_NDF) at graph 0.90, 0.90


set origin 0, 0.4
set size 1, 0.6
set bmargin 0
set tmargin 0.2
set lmargin 10
unset key
unset xlabel
set format x ""
#set xlabel 'Zeit [min]'
set ylabel 'relative Frequenz [MHz]' 0,1
set samples 100000
set xrange [0:120]
plot datafile using (($1-starttime)/60000):4 with linespoints


set origin 0, 0.0
set size 1, 0.4
set tmargin 1
set bmargin 2
set format x "%g"
unset key
set xlabel 'Zeit [min]' 0,0.5
set ylabel 'Jitter [MHz]' -1,0
set ytic 5,5,15
set samples 100000
set xrange [0:120]
set yrange [0:20]
plot datafile using (($1-starttime)/60000):2 with linespoints

unset multiplot
unset out