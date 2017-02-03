all: 
	ghc -O toda.hs;
	./toda > result.txt;
	gnuplot plot.p;
