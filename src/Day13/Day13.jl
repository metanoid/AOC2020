infile = "./src/Day13/input.txt"
f = readlines(infile)
arrival = parse(Int, f[1])
buses = parse.(Int,filter(x -> x != "x", split(f[2], ",")))

function find_next_bus(arrival, buses)
    minutes_since_departure = mod.(arrival, buses)
    if any(minutes_since_departure .== 0)
        idx = findfirst(==(0), minutes_since_departure)
        return buses[idx], 0
    end
    time_to_next = buses .- minutes_since_departure
    idx = findmin(time_to_next)
    return buses[idx[2]], idx[1]
end
id, wait =  find_next_bus(arrival, buses)
id*wait

starttimes = [(parse(Int,step), t - 1) for (t, step) in enumerate(split(f[2],",")) if step != "x"]

function find_match(start_t, multiple, nextbus)
    step, offset = nextbus
    check = start_t
    while mod(check + offset, step) != 0
        check +=  multiple
    end
    multiple = lcm(multiple, step)
    return check, multiple
end

testlist1 = "17,x,13,19"
testlist2 = "67,7,59,61"

find_match(0,17,(13,2))
find_match(102, 221, (19,3))

function find_schedule(starttimes)
    multiple, check = starttimes[1]
    for nextbus in starttimes[2:end]
        check, multiple = find_match(check, multiple, nextbus)
    end
    return check
end

a = find_schedule(starttimes)
