load includedir.'centered.gp'
load includedir.'tex.gp'

outfile = outdir."linsin.svg"
set output outfile

plot sin(x), x lt 3
