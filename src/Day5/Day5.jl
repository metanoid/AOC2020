seatcodes = readlines("./src/Day5/input.txt")
using Chain
seatbin = @chain seatcodes begin
    replace.(_,'R' => '1')
    replace.(_, 'L' => '0')
    replace.(_, 'F' => '0')
    replace.(_, 'B' => '1')
end

rowbin = first.(seatbin, 7)
colbin = last.(seatbin, 3)
rownum = parse.(Int, rowbin, base = 2)
colnum = parse.(Int, colbin, base = 2)

seatid = (8 .* rownum) .+ colnum
max_seat_id = maximum(seatid)


[x for x in 1:max_seat_id if ((x - 1) ∈ seatid) & ((x + 1) ∈ seatid) & (x ∉ seatid)]
