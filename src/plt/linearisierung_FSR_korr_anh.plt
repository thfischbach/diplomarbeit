clear
reset
file1 = "linearisierung_FSR_korr/01"
file2 = "linearisierung_FSR_korr/02"
file3 = "linearisierung_FSR_korr/03"
file4 = "linearisierung_FSR_korr/04"
file5 = "linearisierung_FSR_korr/05"
datafile1 = sprintf('../dat/%s.dat',file1)
datafile2 = sprintf('../dat/%s.dat',file2)
datafile3 = sprintf('../dat/%s.dat',file3)
datafile4 = sprintf('../dat/%s.dat',file4)
datafile5 = sprintf('../dat/%s.dat',file5)


set samples 100000
set term push
set term epslatex color 10 size 7cm, 4.7cm

plot1_title = "\\tiny{zw. Fringes [MHz]}"
plot2_title = "\\tiny{absolut [MHz]}"
set key at 9, 150
set ylabel 'Abweichung [MHz]' 1,0
set xlabel 'Scan Position [GHz]' 0,0.5
set mxtics 5
set mytics 5
set grid ytics lt 1 lc rgbcolor "#f4f4f4" linewidth .1
set tmargin 0.1

set out sprintf('%s.tex',file1)
plot datafile1 using ($1/1000):2 title sprintf('%s', plot1_title) lc 4, \
datafile1 using ($1/1000):3 title sprintf('%s', plot2_title) with lines lt 1 lc 2

unset key
set out sprintf('%s.tex',file2)
plot datafile2 using ($1/1000):2 lc 4, \
datafile2 using ($1/1000):3 with lines lt 1 lc 2

set out sprintf('%s.tex',file3)
plot datafile3 using ($1/1000):2 lc 4, \
datafile3 using ($1/1000):3 with lines lt 1 lc 2

set out sprintf('%s.tex',file4)
plot datafile4 using ($1/1000):2 lc 4, \
datafile4 using ($1/1000):3 with lines lt 1 lc 2

set out sprintf('%s.tex',file5)
plot datafile5 using ($1/1000):2 lc 4, \
datafile5 using ($1/1000):3 with lines lt 1 lc 2

unset out
