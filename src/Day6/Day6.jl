#Day6
answers = readlines("./src/Day6/input.txt")

allgroups = Array{Set,1}()
activegroup = Set()

for an in answers
    if length(an) == 0
        push!(allgroups, copy(activegroup))
        activegroup = Set()
    else
        push!(activegroup, split(an, "")...)
    end
end
if length(activegroup) > 0  # last group might not have ended on a blank line
    push!(allgroups, copy(activegroup))
end

sum(length.(allgroups))


allgroups = Array{Dict,1}()
activegroup = Dict{Char,Int}(collect('a':'z') .=> 0)
activegroup['_'] = 0

for an in answers
    if length(an) == 0
        push!(allgroups, copy(activegroup))
        activegroup = Dict{Char,Int}(collect('a':'z') .=> 0)
        activegroup['_'] = 0
    else
        for r in an
            activegroup[r] += 1
        end
        activegroup['_'] += 1
    end
end
if length(activegroup) > 0  # last group might not have ended on a blank line
    push!(allgroups, copy(activegroup))
end

vals = 0
for i in allgroups
    respondents = i['_']
    val = count(==(respondents), values(i)) - 1
    vals += val
end
vals
