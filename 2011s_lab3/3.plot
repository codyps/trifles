set terminal epslatex size 4.0 in, 2.5 in
set output "include/p3.tex"
set datafile separator "	"

set xlabel "$V_{iB}$ (V)"
set ylabel "$V_o$ / $V_{B4}$ (V)"

plot "3.csv" using 1:3 title "Vo"  with lines lw 2, \
     "3.csv" using 1:5 title "Vb4" with lines lw 2
