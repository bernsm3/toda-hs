set style line 1 lt 2 lc rgb "red" lw 4

infile = 'result.txt'
outfile = 'lattice-sol.gif'

set samples 400
set term gif animate
set termoption enhanced
set xlabel font 'Calibri,14'
set ylabel font 'Calibri,14'
set out outfile
set style line 3
set xlabel "lattice node"
set ylabel "displacement"
set grid back
#set size ratio -1
set key bottom left
#set xrange [0:100]
set yrange [-15:1]

PI=3.14159

N=`awk 'NR==1 {print NF}' result.txt`
do for [i=2:N] {
plot infile u 1:i w l title "t = ".(i-1)."h"
}
#plot infile matrix
set out
