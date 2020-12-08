input = readlines("./src/Day3/input.txt")

function count_trees(input, slope, down)
    pattern = copy(input)
    numtrees = 0
    pos = 1
    width = length(pattern[1])
    for row in 1:down:length(pattern)
        pos = mod(pos - 1, width) + 1
        val = pattern[row][pos]
        letters = string.(split(pattern[row],""))
        if val == '#'
            numtrees += 1
            letters[pos] = "X"
        else
            # print(val)
            letters[pos] = "O"
        end
        pattern[row] = join(letters)
        pos += slope
    end
    return numtrees, pattern
end

hill = copy(input)
num11, pat = count_trees(hill, 1, 1)
num31, pat = count_trees(hill, 3, 1)
num51, pat = count_trees(hill, 5, 1)
num71, pat = count_trees(hill, 7, 1)
num12, pat = count_trees(hill, 1, 2)

num11*num31*num51*num71*num12
