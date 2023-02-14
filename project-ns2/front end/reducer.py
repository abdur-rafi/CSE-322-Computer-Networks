import sys
coeffs = [.3, .45, .4, .3]
coeffs = [.3, 0, 0, 0]

def computCost(words):
    return words[0] * coeffs[0] - words[1] * coeffs[1] \
+ words[2] * coeffs[2] - words[3] * coeffs[3]
    
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
        
