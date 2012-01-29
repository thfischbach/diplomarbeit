clear
reset
file = "laserscan_LUT-kalibriert"
datafile = sprintf('../dat/%s.dat',file)


starttime = 27377708

set samples 100000
set term push
set term epslatex color 10 size 14cm, 5cm
set out sprintf('%s_zoom_04.tex',file)

bm = 0.20
lm = 0.12
rm = 0.95
gap = 0.03
size = 0.75
y1 = 982.0; y2 = 1007.0; y3 = 4493.0; y4 = 4507.0

set multiplot
set xlabel 'Zeit [s]' 0,0.5
set border 1+2+8
unset key
set xtics nomirror
set ytics 5
set lmargin at screen lm
set rmargin at screen rm
set bmargin at screen bm
set tmargin at screen bm + size * (abs(y2-y1) / (abs(y2-y1) + abs(y4-y3) ) )

set yrange [y1:y2]

plot [28:33] datafile using ($1-starttime)/1000:3 with lines title 'Soll-Frequenz', \
datafile using ($1-starttime)/1000:4 with points pt 6 lc 2 title 'Ist-Frequenz'

unset xtics
unset xlabel
set border 2+4+8
set key inside top right
set bmargin at screen bm + size * (abs(y2-y1) / (abs(y2-y1) + abs(y4-y3) ) ) + gap
set tmargin at screen bm + size + gap
set yrange [y3:y4]

set label 'Frequenzverschiebung [MHz]' at screen 0.03, bm + 0.5 * (size + gap) offset 0,-strlen("Frequenzverschiebung [MHz]")/4.0 rotate by 90

set arrow from screen lm - gap / 4.0, bm + size * (abs(y2-y1) / (abs(y2-y1)+abs(y4-y3) ) ) - gap / 4.0 to screen \
lm + gap / 4.0, bm + size * (abs(y2-y1) / (abs(y2-y1) + abs(y4-y3) ) ) + gap / 4.0 nohead

set arrow from screen lm - gap / 4.0, bm + size * (abs(y2-y1) / (abs(y2-y1)+abs(y4-y3) ) ) - gap / 4.0  + gap to screen \
lm + gap / 4.0, bm + size * (abs(y2-y1) / (abs(y2-y1) + abs(y4-y3) ) ) + gap / 4.0 + gap nohead

set arrow from screen rm - gap / 4.0, bm + size * (abs(y2-y1) / (abs(y2-y1)+abs(y4-y3) ) ) - gap / 4.0 to screen \
rm + gap / 4.0, bm + size * (abs(y2-y1) / (abs(y2-y1) + abs(y4-y3) ) ) + gap / 4.0 nohead

set arrow from screen rm - gap / 4.0, bm + size * (abs(y2-y1) / (abs(y2-y1)+abs(y4-y3) ) ) - gap / 4.0  + gap to screen \
rm + gap / 4.0, bm + size * (abs(y2-y1) / (abs(y2-y1) + abs(y4-y3) ) ) + gap / 4.0 + gap nohead

plot [28:33] datafile using ($1-starttime)/1000:3 with lines title 'Soll-Frequenz', \
datafile using ($1-starttime)/1000:4 with points pt 6 lc 2 title 'Ist-Frequenz'

unset multiplot

unset out


