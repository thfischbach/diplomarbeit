clear
reset
file = "laserstabilitaet_alt_alles"
datafile1 = '../dat/laserstabilitaet_alt_freilaufend.dat'
datafile2 = '../dat/laserstabilitaet_alt_FOL.dat'

starttime1 = 1039204987
starttime2 = 1031069746

set term push
set term epslatex color 10 size 15cm, 12cm
set out sprintf('%s.tex',file)
set multiplot


#set fit errorvariables
#set dummy f
#f(x)=a*x+b
#b=14
#a=0.02
#fit f(x) datafile using 1:2:3 via a,b
#set label 1 sprintf('$\chi^2_{\mathrm{red}} = %.4f$',FIT_WSSR/FIT_NDF) at graph 0.90, 0.90


set origin 0, 0.35
set size 1, 0.65
set bmargin 0
set lmargin 10
set key bottom left
unset xlabel
set format x ""
#set xlabel 'Zeit [min]'
set ylabel 'relative Frequenz [MHz]'
set samples 100000
set xrange [0:120]
plot datafile1 using (($1-starttime1)/60000):4 title 'freilaufend' with linespoints lc 1 pt 1 lt 1, \
datafile2 using (($1-starttime2)/60000):4 title 'FOL-stabilisiert' with linespoints lc 2 pt 1 lt 1


set origin 0, 0.2
set size 1, 0.15
set tmargin 1
unset key
unset xlabel
set ylabel 'Jitter [MHz]' 0,-1.5
set ytic 5,5,15
set samples 100000
set xrange [0:120]
set yrange [0:20]
plot datafile1 using (($1-starttime1)/60000):2 title 'freilaufend' with linespoints lc 1


set origin 0, 0.0
set size 1, 0.2
set tmargin 0
set bmargin 3
set format x "%g"
set xlabel 'Zeit [min]'
unset ylabel
set samples 100000
set xrange [0:120]
set yrange [0:20]
plot datafile2 using (($1-starttime2)/60000):2 title 'FOL-stabilisiert' with linespoints lc 2

unset multiplot
unset out