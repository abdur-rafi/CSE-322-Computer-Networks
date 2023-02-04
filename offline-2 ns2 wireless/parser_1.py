# print("hello world")

startTime = -1
endTime = 0
receivedBytes = 0
headerBytes = 8
totalDelay = 0
sentPackets = 0
receivedPackets = 0
droppedPackets = 0

sentTime = dict()

with open("offline.tr", "r") as file:
    count = 0
    while True:
        line = file.readline()
        count += 1
        
        if not line:
            break

        words = line.split()

        time = 0.0
        packetId = 0
        traceLevel = ""
        packetSize = 0
        event = words[0]
        packetType = ""
        f = False

        i = 0
        n = len(words)


        while(i < n):
            if words[i] == "-t":
                time = float(words[i + 1])
                f = True
            elif words[i] == "-Nl":
                traceLevel = words[i + 1]
            elif words[i] == "-Ii":
                packetId = words[i + 1]
            elif words[i] == "-Il":
                packetSize = int(words[i + 1])
            elif words[i] == "-It":
                packetType = words[i + 1]
            i += 1

        # print(time)

        if startTime == -1 and f :
            startTime = time
        
        if endTime < time and f:
            endTime = time
        
        
        if event == "d" and packetType == "exp":
            droppedPackets += 1

        if traceLevel != "AGT" or packetType != "exp":
            continue

        if event == "r":
            receivedBytes += packetSize - headerBytes
            if time == 0:
                print(time)
            # if packetId == "11399":
            #     print(line)
            totalDelay += time - sentTime[packetId]
            receivedPackets += 1

        elif event == "s":
            sentTime[packetId] = time
            sentPackets += 1
        
         
        

print((receivedBytes * 8) / (endTime - startTime), end = " ")
print(totalDelay / receivedPackets, end = " ")
print(receivedPackets / sentPackets, end = " ")
print(droppedPackets / sentPackets, end = " ")
print()
# print(count)