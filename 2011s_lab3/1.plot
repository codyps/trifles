set terminal epslatex size 4.0 in, 2.5 in
set output "include/p1.tex"
set datafile separator "	"

set xlabel "$V_{iB}$ (V)"
set ylabel "$V_o$ (V)"
unset key

plot "1.csv" using 1:2 with lines lw 2
