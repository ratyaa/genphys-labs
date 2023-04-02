set terminal svg noenhanced

outfile = outdir."lab.svg"
set output outfile

set datafile separator ','
set grid xtics ytics mxtics mytics
set mytics 10
set mxtics 10
set xlabel "$\\frac{1}{T} \\cdot 10^3,\\ К^{-1}$"
set ylabel "$\\ln{\\eta},\\ [\\eta] = Па \\cdot с$"
# set xrange [0:400]
# set yrange [0:0.22]

Majorgridclr = "0xD0000000"
Minorgridclr = "0xF0000000"
set grid lt -1 linecolor rgb Majorgridclr, lt -1 linecolor rgb Minorgridclr


set bars 0.25
# set title "$I(h^2),\\quad [I] = 1\\;г \\cdot м^2, \\quad [h^2] = 1\\;см^2$"
set key right bottom
set key width -16

Shadecolor = "#80E0A080"
Inputfile = includedir."lab.csv"

f(x) = k*x + b
fit f(x) Inputfile using 3:1 via k, b

plot Inputfile using 3:1:4:2 with xyerrorbars ls -1 linecolor rgb "red" title "Измерения $\\ln{\\eta}\\left(\\frac{1}{T}\\right)$",\
     f(x) with line title "Аппроксимация по МНК"

