using Measurements
using CSV
using DataFrames


inputfile = ".build/main.csv"
outputfile = "data/main.csv"

formulae = Dict(
    "DeltaU" => [
        ["DeltaU"],
        dU -> dU - 4
    ],
    "Tk" => [
        ["T"],
        t -> t + 273.15
    ],
    "DeltaT" => [
        ["DeltaU", "xi"],
        (dU, xi) -> dU / xi
    ],
    "DeltaPMPa" => [
        ["DeltaP"],
        dP -> dP / 10^2 * 9.80665 * 0.06
    ]
)

raw = DataFrame(CSV.File(inputfile))

function toquantities(raw)
    uncertainties = raw[1:2, All()]
    values = raw[Not(1:2), All()]

    out = values
    
    for name in names(raw)
        sigma = uncertainties[1, name]
        epsilon = uncertainties[2, name]
        
        transform!(out, name =>
            ByRow(value -> value ± (sigma + value * epsilon)) =>
            name)
    end

    return out
end

function calculatequantities(measurements, formulae)
    out = measurements
    
    for (key, value) in formulae
        formula = pop!(value)
        dependencies = pop!(value)

        transform!(out, dependencies =>
            ByRow(formula) =>
            key)
    end

    return out
end

function toplotreadble(frame)
    for name in names(frame)

        transform!(frame, name =>
            ByRow(q -> Measurements.value(q)) =>
            name, name =>
            ByRow(q -> Measurements.uncertainty(q)) =>
            name * "_e",)
    end

    return frame
end

measurements = toquantities(raw)
out = calculatequantities(measurements, formulae)

CSV.write(outputfile, out)

out1 = toplotreadble(out[1:8, ["DeltaPMPa", "DeltaT"]])
out2 = toplotreadble(out[9:16, ["DeltaPMPa", "DeltaT"]])
out3 = toplotreadble(out[17:24, ["DeltaPMPa", "DeltaT"]])

println("20 degrees celsium:")
println(out1)
println("30 degrees celsium:")
println(out2)
println("50 degrees celsium:")
println(out3)

CSV.write("data/20deg.csv", out1)
CSV.write("data/30deg.csv", out2)
CSV.write("data/50deg.csv", out3)

