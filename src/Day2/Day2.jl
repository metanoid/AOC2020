file = "./src/Day2/input.txt"

using CSV, DataFrames

df = CSV.read(file, DataFrame, header = false)
rename!(df, [:Column1 => :Range, :Column2 => :Letter, :Column3 => :Password])
df.Min = parse.(Int, first.(split.(df.Range, "-")))
df.Max = parse.(Int, last.(split.(df.Range, "-")))
df.Letter = replace.(df.Letter, ":" =>"")

function checkpassword(password, letter, Min, Max)
    val = count( i -> (i == letter[1]), password)
    if (val >= Min) & (val <= Max)
        return 1
    else
        return 0
    end
end

vals = checkpassword.(df.Password, df.Letter, df.Min, df.Max)

sum(vals)

function checkpassword2(password, letter, id1, id2)
    l = letter[1] # string to char
    v1 = password[id1] == l ? 1 : 0
    v2 = password[id2] == l ? 1 : 0
    if v1 + v2 == 1
        return 1
    else
        return 0
    end
end

vals2 = checkpassword2.(df.Password, df.Letter, df.Min, df.Max)
sum(vals2)


## Sukera's solution

function parseInput(file)
    data = readlines(joinpath(dirname(@__FILE__), file))
    d = split.(data, ": ")
    map(d) do (x,pw)
        counts, char = split(x)
        low,high = parse.(Int, split(counts, '-'))
        ((low,high,char[1]),pw)
    end
end

function solve(input)
    count(input) do ((low,high,char),pw)
        low <= count(==(char),pw) <= high
    end
end

function solve2(input)
    count(input) do ((low,high,char),pw)
        (pw[low] == char) ⊻ (pw[high] == char)
    end
end

function main(file="test")
    data = parseInput(file)
    solve(data) |> println
    solve2(data) |> println
end

main("input.txt")
