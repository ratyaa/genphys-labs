set terminal svg noenhanced linewidth 0.5
set fit logfile datadir."kappa.fitlog"

outfile = outdir."kappa.svg"
set output outfile

set datafile separator ','
set grid xtics ytics mxtics mytics
set mytics 10
set mxtics 10
set xlabel "$t,\\ ^\\circ C$"
set ylabel "$\\kappa,\\ мВт \\cdot (К \\cdot м)^{-1}$"
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
Inputfile = "../data/kappa.csv"
Inputtable = "../data/kappa_table.csv"

# f(x) = k*x + b
# fit smooth bezier f(x) Inputtable using 1:2 via k, b

plot Inputfile using 1:7:4:8 with xyerrorbars ls -1 linecolor rgb "red" title "Измеренные значения $\\kappa$",\
     Inputtable using 1:2 smooth bezier ls -1 linecolor rgb "green" title "Табличные значения $\\kappa$",\

     