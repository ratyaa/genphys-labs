set terminal svg noenhanced linewidth 0.5
set fit logfile datadir."main.fitlog"

outfile = outdir."main.svg"
set output outfile

set datafile separator ','
set grid xtics ytics mxtics mytics
set mytics 10
set mxtics 10
set xlabel "$Q,\\ мкВт$"
set ylabel "$R_{н},\\ Ом$"
# set xrange [0:400]
# set yrange [0:0.22]

Majorgridclr = "0xD0000000"
Minorgridclr = "0xF0000000"
set grid lt -1 linecolor rgb Majorgridclr, lt -1 linecolor rgb Minorgridclr

set bars 0.25
# set title "$I(h^2),\\quad [I] = 1\\;г \\cdot м^2, \\quad [h^2] = 1\\;см^2$"
set key right bottom
set key width -100

Shadecolor = "#80E0A080"
Inputfile23 = "../data/23deg.csv"
Inputfile35 = "../data/35deg.csv"
Inputfile45 = "../data/45deg.csv"
Inputfile55 = "../data/55deg.csv"
Inputfile70 = "../data/70deg.csv"

f23(x) = k23*x + b23
fit f23(x) Inputfile23 using 5:6 via k23, b23

f35(x) = k35*x + b35
fit f35(x) Inputfile35 using 5:6 via k35, b35

f45(x) = k45*x + b45
fit f45(x) Inputfile45 using 5:6 via k45, b45

f55(x) = k55*x + b55
fit f55(x) Inputfile55 using 5:6 via k55, b55

f70(x) = k70*x + b70
fit f70(x) Inputfile70 using 5:6 via k70, b70

plot Inputfile23 using 5:6:11:12 with xyerrorbars ls -1 linecolor rgb "red" notitle,\
     f23(x) with line title "$t = 23\\ ^\\circ C$",\
     Inputfile35 using 5:6:11:12 with xyerrorbars ls -1 linecolor rgb "red" notitle,\
     f35(x) with line title "$t = 35\\ ^\\circ C$",\
     Inputfile45 using 5:6:11:12 with xyerrorbars ls -1 linecolor rgb "red" notitle,\
     f45(x) with line title "$t = 45\\ ^\\circ C$",\
     Inputfile55 using 5:6:11:12 with xyerrorbars ls -1 linecolor rgb "red" notitle,\
     f55(x) with line title "$t = 55\\ ^\\circ C$",\
     Inputfile70 using 5:6:11:12 with xyerrorbars ls -1 linecolor rgb "red" notitle,\
     f70(x) with line title "$t = 70\\ ^\\circ C$"
