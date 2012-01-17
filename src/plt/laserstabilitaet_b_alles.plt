clear
reset
file = "laserstabilitaet_b_alles"
datafile1 = '../dat/laserstabilitaet_b_freilaufend.dat'
datafile2 = '../dat/laserstabilitaet_b_iScan.dat'
datafile3 = '../dat/laserstabilitaet_b_iScan+FOL.dat'

starttime1 = 436513456
starttime2 = 488507320
starttime3 = 497432425

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


set origin 0, 0.5
set size 1, 0.5
set bmargin 0
set lmargin 10
set key bottom left
unset xlabel
set format x ""
#set xlabel 'Zeit [min]'
set ylabel 'relative Frequenz [MHz]'
set samples 100000
set xrange [0:120]
plot datafile1 using (($1-starttime1)/60000):4 title 'freilaufend' with linespoints lc 1 pt 1, \
datafile2 using (($1-starttime2)/60000):4 title '\textit{iScan}-stabilisiert' with linespoints lc 3 pt 1, \
datafile3 using (($1-starttime3)/60000):4 title '\textit{iScan}+FOL-stabilisiert' with linespoints lc 2 pt 1


set origin 0, 0.35
set size 1, 0.15
set tmargin 1
unset key
unset xlabel
unset ylabel
set ytic 0.5,0.5,1.5
set samples 100000
set xrange [0:120]
set yrange [0:2]
plot datafile1 using (($1-starttime1)/60000):2 title 'freilaufend' with linespoints lc 1


set origin 0, 0.2
set size 1, 0.15
set tmargin 0
unset xlabel
set ylabel 'Jitter [MHz]' 1,0
set samples 100000
set xrange [0:120]
set yrange [0:2]
plot datafile2 using (($1-starttime2)/60000):2 title '\textit{iScan}-stabilisiert' with linespoints lc 3


set origin 0, 0.0
set size 1, 0.2
set bmargin 3
set format x "%g"
set xlabel 'Zeit [min]'
unset ylabel
set samples 100000
set xrange [0:120]
set yrange [0:2]
plot datafile3 using (($1-starttime3)/60000):2 title '\textit{iScan}+FOL-stabilisiert' with linespoints lc 2

unset multiplot
unset out