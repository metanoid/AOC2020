infile = "./src/Day10/input.txt"
input = parse.(Int,readlines(infile))

s = sort(input)
push!(s, maximum(s) + 3)
pushfirst!(s, 0)
d = diff(s)
ones = count(i -> i == 1,d)
threes =  count(i -> i == 3,d)
 ones*threes

test1 = sort([16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4 ])
pushfirst!(test1, 0)
diffs = diff(test1)

# from a particular index, count all the ways to get to the end
function countways!(pathdict, adapters, idx)
    if haskey(pathdict, idx)
        return pathdict[idx]
    end
    if idx == length(adapters)
        return 1
    end
    count = 0
    # can hop by size 1?
    if adapters[idx+1] - adapters[idx] <= 3
        # then this hop is valid, and need number of subsequent hops
        count += countways!(pathdict, adapters, idx + 1)
    end
    # can hop by 2 positions?
    if idx+2 <= length(adapters) && adapters[idx + 2] - adapters[idx] <= 3
        # then this hop is valid, and need number of subsequent hops
        count += countways!(pathdict, adapters, idx + 2)
    end
    # can hop by 3  positions?
    if idx+3 <= length(adapters) && adapters[idx + 3] - adapters[idx] <= 3
        # then this hop is valid, and need number of subsequent hops
        count += countways!(pathdict, adapters, idx + 3)
    end
    pathdict[idx] = count
end

pathdict = Dict{Int,Int}()
countways!(pathdict, adapters, 1)
