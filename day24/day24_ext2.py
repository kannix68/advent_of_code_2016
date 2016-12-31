# Python 2:
# See: <https://www.reddit.com/r/adventofcode/comments/5k1he1/2016_day_24_solutions/>
# '''
# Created on 22.12.2016
#
# '''
import networkx as nx
from itertools import *

FILENAME = "day24_data.txt" #'24.in'

f = open('%s' % FILENAME)
rows = [line.strip() for line in f]

nr,nc,c,d = len(rows),len(rows[0]),dict(),dict()
G = nx.generators.classic.grid_2d_graph(nr,nc)

for i in xrange(nr):
  for j in xrange(nc):
    if rows[i][j]=='#':
      G.remove_node((i,j))
    if rows[i][j].isdigit():
      c[int(rows[i][j])] = (i,j)

for i in xrange(8):
  for j in xrange(8):
    d[i,j]=d[j,i]= nx.shortest_path_length(G,c[i],c[j])

best = 10**100
for p in permutations(range(1,8)):
  #l = [0] + list(p) # PART 1
  l = [0] + list(p) + [0] # PART 2
  t = sum(d[l[i+1],l[i]] for i in xrange(len(l)-1))
  best = min(t,best)
print best