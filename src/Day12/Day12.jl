infile = "./src/Day12/input.txt"
input = readlines(infile)

import Base.:+

import Base.:*

directions = [(x[1:1], parse(Int,x[2:end]) ) for x in input]

struct Point
    x
    y
end
+(a::Point, b::Point) = Point(a.x + b.x, a.y + b.y)
*(a::Point, n::Int) = Point(n*a.x, n*a.y)

function rotate(facing, dir, num)
    x₁ , y₁ = facing.x, facing.y
    if dir == "R"
        num = -num
    end
    x₂ = x₁*cosd(num) - y₁*sind(num)
    y₂ = x₁*sind(num) + y₁*cosd(num)
    return Point(x₂, y₂)
end

testdir = ["F10", "N3", "F7", "R90", "F11"]
testdirections = [(x[1:1], parse(Int,x[2:end]) ) for x in testdir]



function follow_orders(directions, pos, facing)
    visited = Array{Tuple{Point, Point},1}()
    push!(visited,(pos, facing))
    for (d, num) in directions
        if d == "N"
            pos = pos + Point(0, num)
        elseif d == "S"
            pos = pos + Point(0, -num)
        elseif d == "E"
            pos = pos + Point(num, 0)
        elseif d == "W"
            pos = pos + Point(-num, 0)
        elseif d == "L" || d == "R"
            # rotate left by num degrees
            facing = rotate(facing, d, num)
        elseif d == "F"
            pos = pos + (facing*num)
        end
        push!(visited, (pos, facing))
    end
    return pos, visited
end

final_pos, history = follow_orders(directions, Point(0,0), Point(-1, 0))

final_pos
abs(final_pos.x) + abs(final_pos.y)

function track_waypoint(directions, pos, waypoint)
    visited = Array{Tuple{Point, Point},1}()
    push!(visited,(pos, waypoint))
    for (d, num) in directions
        if d == "N"
            waypoint = waypoint + Point(0, num)
        elseif d == "S"
            waypoint = waypoint + Point(0, -num)
        elseif d == "E"
            waypoint = waypoint + Point(num, 0)
        elseif d == "W"
            waypoint = waypoint + Point(-num, 0)
        elseif d == "L" || d == "R"
            # rotate left by num degrees
            waypoint = rotate(waypoint, d, num)
        elseif d == "F"
            pos = pos + (waypoint*num)
        end
        push!(visited, (pos, waypoint))
    end
    return pos, visited
end

p, hist = track_waypoint(directions, Point(0,0), Point(10, 1))
abs(p.x) + abs(p.y)
