infile = "./src/Day11/input.txt"
input = readlines(infile)

seating  = Matrix{String}(undef, length(input), length(input[1]))
for line in 1:length(input)
    s = input[line]
    st = string.(split(s, ""))
    for chr in 1:length(st)
        seating[line, chr] = st[chr]
    end
end

seatmask = [I for I in CartesianIndices((-1:1, -1:1)) if I != CartesianIndex(0,0)]

function update(seating, seatmask)
    newseating = copy(seating)
    neighbours = zeros(Int64, length(input), length(input[1]))
    for I in CartesianIndices(seating)
        for x in seatmask
            if checkbounds(Bool, seating, I + x)
                if seating[I + x] == "#"
                    neighbours[I] += 1
                end
            end
        end
        if seating[I] == "#" && neighbours[I] >= 4
            newseating[I] = "L"
        elseif seating[I] == "L" && neighbours[I] == 0
            newseating[I] = "#"
        end
    end
    return newseating
end


current = copy(seating)
function runtothestables(current, seatmask, maxattempts)
    for i in 1:maxattempts
        current, prev = update(current, seatmask), current
        if all(current .== prev)
            return current, i
        end
    end
    error("Need to increase maxattempts")
end

a,b = runtothestables(current, seatmask, 100)
count(x -> (a[x] == "#"), CartesianIndices(a))

function checkvisibleneighbours(seating, seatmask, pos)
    neighbours = String[]
    for dir in seatmask
        for steps in 1:maximum(size(seating))
            if checkbounds(Bool, seating, pos + steps*dir)
                if seating[pos + steps*dir] != "."
                    push!(neighbours,  seating[pos + steps*dir])
                    break
                end
            else
                break
            end
        end
    end
    return neighbours
end

function part2update(seating, seatmask)
    newseating = copy(seating)
    for I in CartesianIndices(seating)
       n = checkvisibleneighbours(seating, seatmask, I)
       if seating[I] == "#" && count(==("#"), n) >= 5
            newseating[I] = "L"
        elseif seating[I] == "L" && count(==("#"), n) == 0
            newseating[I] = "#"
        end
    end
    return newseating
end

a = part2update(seating, seatmask)

current = copy(seating)
function runtothestables2(current, seatmask, maxattempts)
    for i in 1:maxattempts
        current, prev = part2update(current, seatmask), current
        if all(current .== prev)
            return current, i
        end
    end
    error("Need to increase maxattempts")
end

a, b = runtothestables2(current, seatmask, 100)
count(x -> (a[x] == "#"), CartesianIndices(a))
