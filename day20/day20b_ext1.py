##
# See <https://www.reddit.com/r/adventofcode/comments/5jbeqo/2016_day_20_solutions/dbevbiy/>

FULLRANGE = 2**32 # 4294967296
INFILE = "day20_data.txt"

def get_range(line):
    return map(int, line.split('-'))

def solve(inp):
    ranges = sorted([get_range(line) for line in inp])
    mn, mx = ranges[0]
    tot = 0
    for r in ranges:
        if r[0] > mx+1:
            tot += mx-mn+1
            mn = r[0]
            mx = r[1]
        else:
            mx = max(mx, r[1])
    return FULLRANGE - tot - (mx-mn+1)

inp = [line.strip() for line in open(INFILE).readlines()]
print solve(inp)
