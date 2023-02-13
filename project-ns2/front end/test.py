import sys

with open(sys.argv[1]) as f:
    lines = f.readlines()
    n = len(lines) - 1
    words = lines[n].split(" ")[0:4]
    # words = words[0:3]
    words = [float(i) for i in words]
    # while True:
    line = input()
    # if not line:
    #     break
    words2 = line.split(" ")[0:4]
    words2 = [float(i) for i in words2]
    # print(words, words2)
    for i in range(len(words)):
        if words[i] == 0:
            val = 0
        else:
            val = ((words2[i] - words[i]) / words[i] ) * 100
        print("{:.5f}".format(val), end=" ")
    print()    