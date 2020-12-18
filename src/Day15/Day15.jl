input = "9,12,1,4,17,0,18"
invals = parse.(Int,split(input, ","))

using BenchmarkTools

starting = invals
function part1(starting, finish)
    turntracker = Dict{Int,Array{Int}}()
    numbertracker = zeros(Int, 1,finish)
    for (i,v) in enumerate(starting)
        turntracker[v] = [i]
        numbertracker[i] = v
    end
    prevval = starting[end]
    prevturn = length(starting)

    for turn in (length(starting) + 1):finish
        if !haskey(turntracker, prevval)
            error("Could not find $prevval spoken on turn $turn")
        elseif length(turntracker[prevval]) == 1
            # number only spoken on previous turn, and not before
            val = 0
        else
            # number spoken before, need diff between previous two turns where it was spoken
            pt = turntracker[prevval][(end-1):end]
            val = diff(pt)[1]
        end
        if haskey(turntracker, val)
            push!(turntracker[val], turn)
        else
            turntracker[val] = [turn]
        end
        numbertracker[turn] = val
        prevval = val
    end
    return numbertracker, turntracker
end

n, t = part1(starting, 2020)
n[2020]
using Profile
@profview part1(starting, 2020)

@profview part2n, part2t = part1(starting, 30000000)
