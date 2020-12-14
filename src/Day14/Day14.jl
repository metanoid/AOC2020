infile = "./src/Day14/input.txt"
input = readlines(infile)

function part1(input)
    sp = split.(input, " = ")
    instructions = first.(sp)
    data = last.(sp)
    ln = maximum(length.(data)) # 36
    mask = "X"^ln
    memory = Dict{Int,Int}()
    for i in 1:length(sp)
        if instructions[i] == "mask"
            mask = data[i]
        else
            pointer = parse(Int, match(r"\d+", instructions[i]).match)
            towrite = applymask(mask, parse(Int, data[i]))
            memory[pointer] = towrite
        end
    end
    return memory
end

function applymask(mask, data)
    # convert data to binary
    d = reverse(digits(data, base = 2, pad = 36))
    for (i,v) in enumerate(mask)
        if v != 'X'
            d[i] = parse(Int, v)
        end
    end
    # convert binary to int
    val = parse(Int, join(d,""), base = 2)
    return val
end

function part2(input)
    sp = split.(input, " = ")
    instructions = first.(sp)
    data = last.(sp)
    ln = maximum(length.(data)) # 36
    mask = "X"^ln
    memory = Dict{Int,Int}()
    for i in 1:length(sp)
        if instructions[i] == "mask"
            mask = data[i]
        else
            pointer = parse(Int, match(r"\d+", instructions[i]).match)
            allpointers = applymemmask(mask, pointer)
            d = parse(Int, data[i])
            for p in allpointers
                memory[p] = d
            end
        end
    end
    return memory
end

function applymemmask(mask, pointer)
    allpointers = Int[]
    push!(allpointers, 0)
    l = length(mask)
    pbin = reverse(digits(pointer, base = 2, pad = l))
    for (i, v) in enumerate(mask)
        size = 2^(l - i)
        if v == 'X'
            # double up the entries
            added = allpointers .+ size
            push!(allpointers, added...)
        elseif v == '1'
            allpointers .+= size
        elseif v == '0'
            p = pbin[i]
            if p == 1
                allpointers .+= size
            else
                # nothing
            end
        end
    end
    return allpointers
end

applymemmask("000000000000000000000000000000X1001X", 42)

mem2 = part2(input)
sum(values(mem2))

@time part2(input)
