using Memoize

infile = "./src/Day7/input.txt"
input = readlines(infile)

function parseinput(input)
    rules = Dict{String, Vector{Pair{String, Int}}}()
    splits = split.(input, " bags contain ")
    left, right = string.(first.(splits)) , string.(last.(splits))
    reg = Regex(" bag[s\\.,\\s]+")
    for i in 1:length(left)
        pieces = split(right[i], reg)
        edges = Vector{Pair{String, Int}}()
        for r in pieces
            if length(r) == 0
                continue
            end
            if occursin("no other", r)
                continue
            end
            val = parse(Int, match(r"\d", r).match)
            col = string(match(Regex(join(left, "|")), r).match)
            edge = (col => val)
            push!(edges, edge)
        end
        if length(edges) > 0
            rules[left[i]] = edges
        end
    end
    return rules
end

rules = parseinput(input)

function check_rules!(visited, rules, target)
    # find all bags which can contain the target
    containers = findall(x -> any(==(target), first.(x)), rules)
    # if no bags can contain the target, we're done, return the set found so far
    if length(containers) == 0
        println("Nope, no bags can contain $target")
        return visited
    end
    println("The following bags can contain $target:")
    println.(containers)
    # include the set of containers we've found in our list
    push!(visited, containers...)
    # now find *their* containers, and push into visited
    for p in containers
        check_rules!(visited, rules, p)
    end
    return visited
end

can_reach_shinygold = check_rules!(Set{String}(), rules, "shiny gold")

function check_contents(rules, target)
    if !haskey(rules, target)
        return 0
    end
    innards = rules[target]
    total = 0
    for (col, val) in innards
        #println("Adding $val bags of colour $col")
        total += val * (1 + check_contents(rules, col))
        #println(total)
    end
    return total
end

bag_count = check_contents(rules, "shiny gold")
