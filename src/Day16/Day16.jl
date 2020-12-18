infile = "./src/Day16/input.txt"
input = readlines(infile)

function parse_input(infile)
    rules, myticket, nearby = open(infile) do f
        line = 1
        part = 1
        rules = Dict{String,Vector{UnitRange{Int64}}}()
        nearby = Vector{Vector{Int}}()
        while !eof(f)
            x = readline(f)
            if x == ""
                part += 1
                continue
            elseif x == "your ticket:"
                part = 2
                continue
            elseif x == "nearby tickets:"
                part = 3
                continue
            end
            if part == 1
                rulename, textranges = split(x, ": ")
                ranges = parserange.(split(textranges, " or "))
                rules[rulename] = ranges
            end
            if part == 2
                myticket = parse.(Int, split(x, ","))
            end
            if part == 3
                thisticket = parse.(Int, split(x, ","))
                push!(nearby, thisticket)
            end
        end
        return rules, myticket, nearby
    end
    return rules, myticket, nearby
end


function parserange(txt)
    left, right = parse.(Int, split(txt, "-"))
    return left:right
end

function find_invalid_values(tickets, rules)
    invalids = Vector{Int}()
    invalidtickets = Set{Int}()
    for (num, ticket) in enumerate(tickets)
        ticketvalid = false
        for (f,field) in enumerate(ticket)
            valid = false
            for rule in values(rules)
                if any(field .∈ rule)
                    valid = true
                    break
                end
            end
            if !valid
                push!(invalids, field)
                push!(invalidtickets, num)
                # println("Field $f on ticket $num invalid")
            end
        end
    end
    return invalids, invalidtickets
end

rules, myticket, nearby = parse_input(infile)

badfields, badtickets = find_invalid_values(nearby, rules)
validnearby = [nearby[x] for x in 1:length(nearby) if x ∉ badtickets]

# assign field to column
ruletocol = Dict{String, Set{Int}}()
coltorule = Dict{Int, Set{String}}()
for (rulename, ranges) in rules
    for col in 1:length(validnearby[1])
        valid = all([any(x[col] .∈ ranges) for x in validnearby])
        if valid
            if haskey(ruletocol, rulename)
                push!(ruletocol[rulename], col)
            else
                ruletocol[rulename] = Set(col)
            end
            if haskey(coltorule, col)
                push!(coltorule[col], rulename)
            else
                coltorule[col] = Set((rulename,))
            end
        end
    end
end

finalassignments = Dict{String, Int}()
# make logical assignments
# while any(length(values(coltorule)) .> 1)
for i in 1:20
    for (col, colrules) in coltorule
        if length(colrules) == 1
            # then this assignment is final and cannot be used elsewhere
            finalassignments[only(colrules)] = col
            # run through all other rules and remove this link
            for (othercol, otherrules) in coltorule
                if othercol != col
                    delete!(coltorule[othercol], only(colrules))
                end
            end
        end
    end
end

departurecols = [col for (name, col) in finalassignments if contains(name, "departure")]
departurevals = myticket[departurecols]
part2 = prod(departurevals)
