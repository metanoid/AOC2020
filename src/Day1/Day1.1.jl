using CSV

input = CSV.read("./src/Day1/input.txt", Tuple, header = false)
inputarray = input[1]
# inputarray = [1721
# 979
# 366
# 299
# 675
# 1456]

for i in 1:(length(inputarray) - 1), j in (i+1):length(inputarray)
    sum = inputarray[i] + inputarray[j]
    if sum == 2020
        prod = inputarray[i] * inputarray[j]
        println(inputarray[i])
        println(inputarray[j])
        println(prod)
    end
end

function sumfinder(inputarray, numentries, target, currentsum, currentvals)
    if length(inputarray) < numentries
        # no solution is possible
        return nothing
    elseif length(inputarray) == numentries
        if sum(inputarray) + currentsum == target
            # solution found
            soln = vcat(currentvals, inputarray)
            return soln
        else
            # solution does not exist
            return nothing
        end
    elseif length(inputarray) == 0
        # solution does not exist
        return nothing
    elseif numentries <= 0
        if currentsum == target
            # solution found
            soln = currentvals
            return soln
        else
            # solution does not exist
            return nothing
        end
    else
        for i in 1:(length(inputarray) - numentries)
            picked = inputarray[i]
            newarray = inputarray[(i+1):end]
            newsum = currentsum + picked
            newvals = vcat(currentvals, picked)
            test = sumfinder(newarray, numentries - 1, target, newsum, newvals)
            if !isnothing(test)
                soln = test
                return soln
            end
        end
        return nothing
    end
end

a = sumfinder(inputarray, 3, 2020, 0, [])
prod(a)
