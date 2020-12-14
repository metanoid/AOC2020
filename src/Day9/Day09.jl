infile = "./src/Day9/input.txt"
input = parse.(Int,readlines(infile))

# part 1, check that each number can be the sum of any 2 of the prior 25
# find first anomaly

function checkpairs(bank, target)
    for i in 1:(length(bank)-1), j in (i+1):length(bank)
        check = bank[i] + bank[j] == target
        if check
            return true
        end
    end
    return false
end

bank = input[1:25]
target = input[26]
checkpairs(bank, target)

function findanomaly(input)
    bank = input[1:25]
    for test in 26:length(input)
        target = input[test]
        if !checkpairs(bank, target)
            return target, test
        end
        discard = popfirst!(bank)
        push!(bank, target)
    end
    return 0, 0
end
anomaly, pos = findanomaly(input)

function breakencryption(input, anomaly)
    for start in 1:(length(input) - 1)
        for finish in (start+1):length(input)
            adds = sum(input[start:finish])
            if adds > anomaly
                break # end finish loop
            end
            if adds == anomaly
                return start, finish, minimum(input[start:finish]), maximum(input[start:finish])
            end
        end
    end
    return 0,0,0,0
end



start, finish, small, big = breakencryption(input, anomaly)
sum(input[518:534])
small + big
