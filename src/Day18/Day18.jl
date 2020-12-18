infile = "./src/Day18/input.txt"
input = readlines(infile)

±(a,b) = a * b

part1 = open(infile) do f
    total = 0
    while !eof(f)
        x = readline(f)
        # replace the * with a symbol that has the same operator precedence as +
        s = replace(x, '*' => '±')
        expr = Meta.parse(s)
        val = eval(expr)
        println(val)
        total += val
    end
    return total
end

⋅(a,b) = a + b

part2 = open(infile) do f
    total = 0
    while !eof(f)
        x = readline(f)
        # replace the * with a symbol that has the same operator precedence as +
        # replace the + with a symbol that has the same operator precedence as *
        s = replace(replace(x, '*' => '±'), '+' => '⋅')
        expr = Meta.parse(s)
        val = eval(expr)
        println(val)
        total += val
    end
    return total
end
