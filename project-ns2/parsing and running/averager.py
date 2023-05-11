import sys
sum = []
count = 0
for line in open(sys.argv[1]):
    if(len(line) == 1):
        for b in sum:
            print(b / count , end = " ")
        print()
        sum = []
        count = 0
    else:
        line = line[0 : -2]
        words = [float(word) for word in line.split(" ")]
        if len(sum) == 0:
            sum = words
        else:
            for i in range(len(words)):
                sum[i] += words[i]
        count += 1
        
