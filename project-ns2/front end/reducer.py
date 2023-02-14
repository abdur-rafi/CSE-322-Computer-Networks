import sys
def computCost(words):
    return words[0] * .3 - words[1] * .45 + words[2] * .4 - words[3] * .3
best = []
mxCost = -1000000
for line in open(sys.argv[1]):
    if(len(line) == 1):
        # print(mxCost)
        # print(best)
        for b in best:
            print(b , end = " ")
        print()
        best = []
        mxCost = -1000000
    else:
        line = line[0 : -2]
        words = [float(word) for word in line.split(" ")]
        cost = computCost(words)
        if cost > mxCost:
            mxCost = cost
            best = words
        
