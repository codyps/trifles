set terminal epslatex size 4.0 in, 2.5 in
set output "include/p4.tex"
set datafile separator "	"

set xlabel "$V_{iB}$ (V)"
set ylabel "$V_o$ / $V_{B3}$ (V)"

plot "3.csv" usi 1:2 title "Vo" w lines lw 2,\
     "3.csv" usi 1:4 title "Vb3" w lines lw 2
