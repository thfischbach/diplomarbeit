clear
reset
file="quadratursignale"
set key inside top right
set samples 100000

a(alpha,phi,E0) = E0**2/4*cos(alpha)**2*(1+sin(phi))
b(alpha,phi,E0) = E0**2/4*sin(alpha)**2*(1+cos(phi))

set term push
set term epslatex color 10
set out sprintf('%s.tex',file)

set multiplot

set origin 0,0
set size 0.4,0.8

set xlabel 'Phase $\nicefrac{\phi}{\pi}$'
set ylabel 'Intensit{"a}t $\nicefrac{}{E_0^2}$' 2.5,0
set xrange [0:2]
set yrange [0:0.35]
set ytics 0.1

set obj 1 circle fc lt 3 at 1./5.,a(pi/4,pi/5,1.0)
set obj 2 circle fc lt 3 at 1./5.,b(pi/4,pi/5,1.0)

plot a(pi/4,x*pi,1.0) title '$I_x$' lt 1 lc 1, \
b(pi/4,x*pi,1.0) title '$I_y$' lt 1 lc 2


set origin 0.3,0
set size square 0.8,0.8

unset obj 1
unset obj 2
set arrow 1 from a(pi/4,0,1.0),b(pi/4,pi/2,1.0) to a(pi/4,pi/5,1.0),b(pi/4,pi/5,1.0)
set obj 3 circle fc lt 3 at a(pi/4,pi/5,1.0),b(pi/4,pi/5,1.0)
set label '$\phi$' at a(pi/4,0,1.0)+0.002,b(pi/4,pi/2,1.0)+0.03

set parametric
set xlabel 'Intensit{"a}t $\nicefrac{I_x}{E_0^2}$'
set ylabel 'Intensit{"a}t $\nicefrac{I_y}{E_0^2}$' 2.5,0
set xrange [-0.02:0.27]
set yrange [-0.02:0.27]
set xtics 0.1
set ytics 0.1
set mxtics 4
set mytics 4
set grid xtics ytics mxtics mytics

plot [0:2*pi] a(pi/4,t,1.0),b(pi/4,t,1.0) lt 1 lc 1 notitle,\
sin(t/10)*0.05+a(pi/4,0,1.0),cos(t/10)*0.05+b(pi/4,pi/2,1.0) lt 1 lc 7 notitle



unset multiplot
unset out
set term pop