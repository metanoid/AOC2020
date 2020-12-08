infile = "./src/Day8/input.txt"
input = readlines(infile)
insplit = split.(input, " ")
opcodes = first.(insplit)
vals = parse.(Int,last.(insplit))

mutable struct Line
    opcode::Symbol
    val::Int64
    count::Int64
end

lines = Dict{Int,Line}()
for i in 1:length(opcodes)
    l = Line(Symbol(opcodes[i]), vals[i], 0)
    lines[i] = l
end


function run(lines)
    currentno = 1
    maxrun = 0
    acc = 0
    while maxrun <= 1
        if !haskey(lines, currentno)
            return acc, true
        end
        currentline = lines[currentno]
        #println("Reached $currentno: $currentline")
        maxrun = currentline.count
        if currentline.count == 1
            # about to run a second time
            return acc, false
        end
        if currentline.opcode == :jmp
            currentno += currentline.val
            currentline.count += 1
        elseif currentline.opcode == :acc
            acc += currentline.val
            currentline.count += 1
            currentno += 1
        elseif currentline.opcode == :nop
            currentline.count += 1
            currentno += 1
        else
            error("Was on line $currentno and died")
        end
    end
    return 0, false
end

l = deepcopy(lines)

run(l)

function fix(lines)
    maybechange = findall(x -> x.opcode ∈ (:jmp, :nop), lines)
    for ix in maybechange
        fixed = deepcopy(lines)
        fixline = fixed[ix]
        if fixline.opcode == :jmp
            fixline.opcode = :nop
        else
            fixline.opcode = :jmp
        end
        val, status = run(fixed)
        if status
            return val, ix
        end
    end
    error("Nope")
end

l = deepcopy(lines)
fix(l)
