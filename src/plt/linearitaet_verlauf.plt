clear
reset
file = "linearitaet_verlauf"
datafile = sprintf('../dat/%s.dat',file)
datafile1 = sprintf('../dat/%s/01.dat',file)
datafile2 = sprintf('../dat/%s/17.dat',file)
datafile3 = sprintf('../dat/%s/26.dat',file)


set samples 100000
set term push
set term epslatex color 10 size 13cm, 17cm
set out sprintf('%s.tex',file)
set multiplot

starttime = 1312216015

plot1_title = "\\tiny{zw. Fringes [MHz]}"
plot2_title = "\\tiny{absolut [MHz]}"
set key at 9, -30
set ylabel 'Abweichung [MHz]' 0.7,0
set mxtics 5
set mytics 5
set xtics 0,2,8
set xrange [-1:9]
#set grid ytics lt 1 lc rgbcolor "#f4f4f4" linewidth .1
set yrange [-70:30]
set ytics -60,20,20
set bmargin 0.1
set lmargin 0
set rmargin 0
set tmargin 0.1
unset xlabel
#set format x ""


#################
#	Einzelplots	#
#################


set origin 0, 0.7
set size 0.333, 0.3
set xlabel 'Scan Position [GHz]' 0,0.5
set label 1 "A" at graph 0.45, 0.9
set label 2 "\\tiny{max. m\"ogl. Abweichung: $11.2$ MHz}" at 0,-55
plot datafile1 using ($1/1000):2 title sprintf('%s', plot1_title) lc 4, \
datafile1 using ($1/1000):3 title sprintf('%s', plot2_title) with lines lt 1 lc 2

set origin 0.333, 0.7
set size 0.333, 0.3
set xlabel 'Scan Position [GHz]' 0,0.5
unset ylabel
unset key
set format y ""
set label 1 "B" at graph 0.45, 0.9
set label 2 "\\tiny{max. m\"ogl. Abweichung: $54.2$ MHz}" at 0,-55
plot datafile2 using ($1/1000):2 title sprintf('%s', plot1_title) lc 4, \
datafile2 using ($1/1000):3 title sprintf('%s', plot2_title) with lines lt 1 lc 2

set origin 0.666, 0.7
set size 0.333, 0.3
set xlabel 'Scan Position [GHz]' 0,0.5
set rmargin 0.1
set label 1 "C" at graph 0.45, 0.9
set label 2 "\\tiny{max. m\"ogl. Abweichung: $79.8$ MHz}" at 0,-55
plot datafile3 using ($1/1000):2 title sprintf('%s', plot1_title) lc 4, \
datafile3 using ($1/1000):3 title sprintf('%s', plot2_title) with lines lt 1 lc 2

#set format x2 ""
set autoscale x


#################
#	Scanfehler	#
#################


set yrange [0:100]
set ylabel 'max. Scanfehler [MHz]'
unset xlabel
set xtics 0,30,270
set mxtics 3
set xrange [-30:300]
set format y "%g"
set ytics 10,10,90
set origin 0, 0.3
set size 1, 0.32
set bmargin 0.1
#set lmargin 10
#set xdata time
#set timefmt "%d.%m.%Y %H:%M:%S"
set format x ""

set label 1 "A" at (1312216015.-starttime)/60.-3,33
set label 2 "B" at (1312221020.-starttime)/60.-3,73
set label 3 "C" at (1312223925.-starttime)/60.-3+23,87

set arrow 1 from (1312216015.-starttime)/60.,30 to (1312216015.-starttime)/60., 11.215245 back
set arrow 2 from (1312221020.-starttime)/60.,70 to (1312221020.-starttime)/60., 54.175544 back
set arrow 3 from (1312223925.-starttime)/60.+20,85 to (1312223925.-starttime)/60., 79.792508 back

plot datafile using (($5-starttime)/60.):2 with lines, \
datafile using (($5-starttime)/60.):2 with points pt 2 lc 2




#################
#	FSR Fehler	#
#################

set ylabel 'FSR-Fehler [MHz]'
set xlabel 'Zeit [min]'
#set format x "%H:%M"
set format x "%g"
set ytics -6,2,6
set yrange [-8:8]
set origin 0, 0
set size 1, 0.3
set bmargin 5
#set lmargin 8.2

unset label 1
unset label 2
unset label 3

unset arrow 1
unset arrow 2
unset arrow 3

plot datafile using (($5-starttime)/60):4 with lines, \
datafile using (($5-starttime)/60):4 with points pt 2 lc 2

unset multiplot
unset out
