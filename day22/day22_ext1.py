# Python 3:
# See: <https://www.reddit.com/r/adventofcode/comments/5jor9q/2016_day_22_solutions/>
# '''
# Created on 22.12.2016
#
# '''
import re
import collections

FILENAME = "day22_data.txt" #'input22.dat'

Node = collections.namedtuple('node', ['used', 'avail'])
Cord = collections.namedtuple('coord', ['x', 'y'])
nodeDict = {}

maxX = 0
maxY = 0

def bringDataToFront(freespace, dataSpace, nodeDict):
  steps = 0
  while dataSpace != Cord(0, 0):
    if freespace.x < dataSpace.x and freespace.y == dataSpace.y:
      steps += routeFreeSpace(freespace, dataSpace, nodeDict)
      freespace, dataSpace = dataSpace, freespace
    elif freespace.x > dataSpace.x and freespace.y == dataSpace.y:
      steps += routeFreeSpace(freespace, Cord(freespace.x, freespace.y + 1), nodeDict)
      freespace = Cord(freespace.x, freespace.y + 1)
    elif freespace.x > dataSpace.x and freespace.y > dataSpace.y:
      steps += routeFreeSpace(freespace, Cord(freespace.x - 1, freespace.y), nodeDict)
      freespace = Cord(freespace.x - 1, freespace.y)
    elif freespace.x == dataSpace.x and freespace.y > dataSpace.y:
      steps += routeFreeSpace(freespace, Cord(freespace.x - 1, freespace.y), nodeDict)
      freespace = Cord(freespace.x - 1, freespace.y)
    elif freespace.x < dataSpace.x and freespace.y > dataSpace.y:
      steps += routeFreeSpace(freespace, Cord(freespace.x, freespace.y - 1), nodeDict)
      freespace = Cord(freespace.x, freespace.y - 1)
  return steps


def routeFreeSpace(src, dst, nodeDict):
  cur = src
  steps = 0

  while cur.y != dst.y:
    old = cur
    if cur.y < dst.y:
      cur = Cord(cur.x, cur.y + 1)
    else:
      cur = Cord(cur.x, cur.y - 1)
    steps += 1
    nodeDict[old], nodeDict[cur] = nodeDict[cur], nodeDict[old]
  while cur.x != dst.x:
    old = cur
    if cur.x < dst.x:
      cur = Cord(cur.x + 1, cur.y)
    else:
      cur = Cord(cur.x - 1, cur.y)
    steps += 1
    nodeDict[old], nodeDict[cur] = nodeDict[cur], nodeDict[old]
  return steps


def printGrid(nodeDict):
  for y in range(-1, maxY):
    for x in range(-1, maxX):
      if y == -1 and x == -1:
        pass
      elif y == -1:
        print(x, end="\t ")
      elif x == -1:
        print(y, end="\t ")
      else:
        print("{0}/{1}".format(nodeDict[(x, y)].used, nodeDict[(x, y)].avail), end="\t ")
      print()

with open(FILENAME) as file:
  for line in file:
    line.rstrip()
    numbers = list(map(int, re.findall('\d+', line)))
    # print(numbers)
    if len(numbers) == 0:
      continue
    nodeDict[Cord(numbers[0], numbers[1])] = Node(numbers[3], numbers[4])
    maxX = max(maxX, numbers[0])
    maxY = max(maxY, numbers[1])
numberValidNodes = 0
validList = []
print(maxX)
print(maxY)

for outerKey, outerValue in nodeDict.items():
  for innerKey, innerValue in nodeDict.items():
    if outerValue.used == 0:
      continue
    if (outerKey == innerKey):
      continue;
    if outerValue.used < innerValue.avail:
      numberValidNodes += 1

      # validList.append((outerKey,innerKey,outerValue,innerValue))
print("Part1 {0}".format(numberValidNodes))

outerKey = (maxX, 0)
freespace = (0, 0)
outerValue = nodeDict[outerKey]
for innerKey, innerValue in nodeDict.items():
  if outerValue.used == 0:
    continue
  if (outerKey == innerKey):
    continue;
  if outerValue.used < innerValue.avail:
    freespace = innerKey
    print(innerKey)
    print(innerValue.avail)
    print(outerValue.used)

printGrid(nodeDict)
print(nodeDict[Cord(maxX, 0)])
steps = routeFreeSpace(freespace, Cord(0, freespace.y), nodeDict)
freespace = Cord(0, freespace.y)
steps += routeFreeSpace(freespace, Cord(maxX - 1, 0), nodeDict)

print(steps)
print(nodeDict[Cord(maxX - 1, 0)])
steps += bringDataToFront(Cord(maxX - 1, 0), Cord(maxX, 0), nodeDict)
print(steps)
print(nodeDict[Cord(0, 0)])
