infile = "./src/Day4/input.txt"
a = split(join(readlines(infile, keep = true)), "\n\n")

validcount = 0
invalidcount = 0
passport = Set{String}()

# part 1
requiredfields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"] # cid
for row in a
    fields = split(row, ['\n', ' '])
    fieldnames = first.(split.(fields, ":"))
    fieldset = Set(fieldnames)
    if all(in(fieldset).(requiredfields))
        validcount += 1
    else
        invalidcount += 1
    end
end
validcount

# part 2

validcount = 0
invalidcount = 0
# passport = Dict{String, String}()
for row in a
    fields = split(row, ['\n', ' '])
    fieldnames = first.(split.(fields, ":"))
    fieldvals =  last.(split.(fields, ":"))
    fieldset = Set(fieldnames)
    if all(in(fieldset).(requiredfields))
        # then check values
        valid = true
        passport = Dict(fieldnames .=> fieldvals)
        # byr (Birth Year) - four digits; at least 1920 and at most 2002.
        if length(passport["byr"]) != 4
            valid = false
        end
        byr = parse(Int, passport["byr"])
        if (byr < 1920) | (byr > 2020)
            valid = false
        end
        # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
        if length(passport["iyr"]) != 4
            valid = false
        end
        iyr = parse(Int, passport["iyr"])
        if (iyr < 2010) | (iyr > 2020)
            valid = false
        end

        # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
        if length(passport["eyr"]) != 4
            valid = false
        end
        eyr = parse(Int, passport["eyr"])
        if (eyr < 2020) | (eyr > 2030)
            valid = false
        end
        # hgt (Height) - a number followed by either cm or in:
        # If cm, the number must be at least 150 and at most 193.
        # If in, the number must be at least 59 and at most 76.
        # println(passport["hgt"])
        hgt_string = passport["hgt"]
        if length(hgt_string) > 2
            hgt_units = hgt_string[(end-1):end]
            hgt_value = parse(Int, hgt_string[1:(end-2)])
            if hgt_units == "cm"
                if (hgt_value < 150) | (hgt_value > 193)
                    valid = false
                end
            elseif hgt_units == "in"
                if (hgt_value < 59) | (hgt_value > 76)
                    valid = false
                end
            end
        else
            valid = false
        end
        # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
        if !occursin(r"^#[0-9a-f]{6}$", passport["hcl"])
            valid = false
        end

        # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
        if !(passport["ecl"] in ["amb","blu","brn","gry","grn","hzl","oth"])
            valid = false
        end

        # pid (Passport ID) - a nine-digit number, including leading zeroes.
        if !occursin(r"^\d{9}$", passport["pid"])
            valid = false
        end
        # cid (Country ID) - ignored, missing or not.

        if valid
            validcount += 1
        else
            invalidcount += 1
        end
    else
        invalidcount += 1
    end
end
validcount
invalidcount
