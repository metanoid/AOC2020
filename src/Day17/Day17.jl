infile = "./src/Day17/input.txt"
input = readlines(infile)

using DataStructures

cube = Dict{CartesianIndex, Bool}()
for x = 1:length(input[1]), y in 1:length(input)
    z = 0
    if input[y][x] == '#'
        cube[CartesianIndex(x,y,z)] = true
    end
end

neighbourgrid = CartesianIndices((-1:1, -1:1, -1:1))


function countactiveneighbours(cube, loc, neighbourgrid)
    grid = loc .+ neighbourgrid
    neighbours = sum(cube[i] for i in grid if haskey(cube, i))
    if haskey(cube, loc)
        count = cube[loc] ? neighbours - 1 : neighbours
    else
        count = neighbours
    end
    return count
end

test = countactiveneighbours(cube, CartesianIndex(8,6,0), neighbourgrid)

function getnext(cube, neighbourgrid)
    nextcube = Dict{CartesianIndex, Bool}()
    for centre in keys(cube)
        # println("Centre is $centre")
        # ps = centre .+ neighbourgrid
        for p in (centre .+ neighbourgrid)
            # println("Current point: $p")
            if haskey(nextcube, p)
                # already pre-calculated
                # println("Pre-done")
                continue
            end
            mystate = haskey(cube, p) ? cube[p] : false
            neighbourcount = countactiveneighbours( cube, p, neighbourgrid)
            if mystate
                if (neighbourcount == 2) || ( neighbourcount == 3)
                    active = true
                else
                    active = false
                end
            else
                if neighbourcount == 3
                    active = true
                else
                    active = false
                end
            end
            nextcube[p] = active
        end
    end
    return nextcube
end

t = getnext(cube, neighbourgrid)

cycles = 6
function part1(cube, neighbourgrid, cycles)
    for i in 1:cycles
        cube = getnext(cube, neighbourgrid)
    end
    return cube
end

cube
sixthcube = part1(cube, neighbourgrid, cycles)
active6 = sum(v for v in values(sixthcube))

neighbourgrid2 = CartesianIndices((-1:1, -1:1, -1:1, -1:1))

cube2 = Dict{CartesianIndex, Bool}()
for x = 1:length(input[1]), y in 1:length(input)
    z = 0
    w = 0
    if input[y][x] == '#'
        cube2[CartesianIndex(x,y,z,w)] = true
    end
end

using BenchmarkTools
@profview part2 = part1(cube2, neighbourgrid2, cycles)
activepart2 = sum(v for v in values(part2))
@benchmark part1(cube2, neighbourgrid2, 3)
