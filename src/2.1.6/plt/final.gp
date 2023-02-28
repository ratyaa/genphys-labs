set terminal svg noenhanced
set fit logfile datadir."final.fitlog"

outfile = outdir."final.svg"
set output outfile

set datafile separator ','
set grid xtics ytics mxtics mytics
set mytics 10
set mxtics 10
set xlabel "$T^{-1},\\ К^{-1}$"
set ylabel "$\\mu_{д-т},\\ К \\cdot МПа^{-1}$"
# set xrange [0:400]
# set yrange [0:0.22]

Majorgridclr = "0xD0000000"
Minorgridclr = "0xF0000000"
set grid lt -1 linecolor rgb Majorgridclr, lt -1 linecolor rgb Minorgridclr


set bars 0.25
# set title "$I(h^2),\\quad [I] = 1\\;г \\cdot м^2, \\quad [h^2] = 1\\;см^2$"
set key right bottom
set key width -29

Shadecolor = "#80E0A080"
Inputfile = "../include/final.csv"

f(x) = k*x + b
fit f(x) Inputfile using 1:2 via k, b

plot Inputfile using 1:2:3:4 with xyerrorbars ls -1 linecolor rgb "red" title "Измерения $\\mu_{д-т}\\left(T^{-1}\\right)$",\
     f(x) with line title "Аппроксимация по МНК"
