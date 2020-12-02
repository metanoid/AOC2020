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
