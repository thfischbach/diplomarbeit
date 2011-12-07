clear
reset
file="k-matrix_wirkungsquerschnitt"
set key inside top left
set xlabel 'E'
set ylabel '$\sigma$'
set samples 100000
set xrange [-100:600]
set yrange [1000:2000000]
set logscale y

f(q1,q2,E1,E2,g1,g2,E) = (1+g1/2/(E1-E)*q1+g2/2/(E2-E)*q2)**2/(1+(g1/2/(E1-E)+g2/2/(E2-E))**2)
#set label 1 sprintf('$\chi^2_{\mathrm{red}} = %.4f$',FIT_WSSR/FIT_NDF) at graph 0.02, 0.80

set term push
set term epslatex color 10
set out sprintf('%s.tex',file)

plot f(50,1000,50,400,2,100,x) title "$q_1=50$" lt 1 lc 1, \
f(100,1000,50,400,2,100,x) title "$q_1=100$" lt 1 lc 2, \
f(200,1000,50,400,2,100,x) title "$q_1=200$" lt 1 lc 3, \
f(300,1000,50,400,2,100,x) title "$q_1=300$" lt 1 lc 4, \
f(400,1000,50,400,2,100,x) title "$q_1=400$" lt 1 lc 5

unset out
set term pop