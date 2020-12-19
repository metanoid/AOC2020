infile = "./src/Day19/input.txt"
input = readlines(infile)

sep = findfirst(x -> x == "", input)
rules = input[1:(sep-1)]
messages = input[(sep+1):end]


ruledict = Dict{Int, String}()
for r in rules 
    ids, spec = split(r, ": ")
    id = parse(Int, ids)
    ruledict[id] = string(spec)
end    

function parserule(rid)
    spec = ruledict[rid]
    parts = string.(split(spec, " "))
    fresh = Vector{String}()
    for (i,p) in enumerate(parts) 
        if contains(p,'"')
            # string literal
            push!(fresh, p)
        elseif contains(p, '|')
            # or function 
            push!(fresh, p)
        else 
            subid = parse(Int, p)
            if subid == rid 
                if subid == 8
                    override = "$(fresh[i-1])+"
                    fresh = override 
                    break
                elseif subid == 11
                    left = parserule(parse(Int, parts[i-1]))
                    right = parserule(parse(Int, parts[i+1]))
                    override = ["($(left)){$j}($(right)){$j}" for j in 1:5]
                    fresh = override
                    break
                end
            else
                subrule = parserule(subid)
                wrap = "($subrule)"
                push!(fresh, wrap)
            end
        end
    end
    updated = join(fresh, " ")
    ruledict[rid] = updated
end
            
backup = deepcopy(ruledict)
# ruledict = deepcopy(backup)
parserule(0)
function cleanrule(rid)
    rule = ruledict[rid]
    clean = replace(rule, "\"" => "")
    short = replace(clean, " " => "")
    # trimmed = replace(short, r"\(a\)\(a\)" => "(aa)")
    # trimmed = replace(trimmed, r"\(a\)\(b\)" => "(ab)")
    # trimmed = replace(trimmed, r"\(b\)\(a\)" => "(ba)")
    # trimmed = replace(trimmed, r"\(b\)\(b\)" => "(bb)")
    # trimmed = replace(trimmed, r"\(\(([ab]+)\)\)" => s"(\1)")
    ruledict[rid] = short
end
cleanrule(0)

reg = Regex("^$(ruledict[0])\$")
matches = match.(reg, messages)
matchey = filter(x -> x !== nothing, matches)
length(matchey)
backup[0]

# part2
# resets

ruledict[0] = backup[0]
ruledict[8] = "42 | 42 8"
ruledict[11] = "42 31 | 42 11 31"
parserule(0)
cleanrule(0)
cleanrule(8)
cleanrule(11)
cleanrule(42)
cleanrule(31)

customrules = ["($(ruledict[42])){1,}(($(ruledict[42])){$n}($(ruledict[31])){$n})" for n in 1:5]

regc = [Regex("^$(c)\$") for c in customrules]

matches = [length(filter(!isnothing, match.(re, messages))) for re in regc]
sum(matches)
mat = filter(!isnothing, matches);
length(mat)

reg42 = Regex("^($(ruledict[42])){2,}")
reg31 = Regex("($(ruledict[8])){1,}\$")
match42 = match.(reg42, messages);
match31 = match.(reg31, messages);

valid = 0
for m in messages 
    left = match(reg42, m)
    if left === nothing
        continue
    end
    v = replace(m, reg42 => "_")
    println(v)
    right = match(reg31, v)
    if right === nothing 
        continue
    else 
        valid += 1
    end
end

valid