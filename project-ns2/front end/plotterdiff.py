import matplotlib.pyplot as plt
import sys

xs = [[20, 40, 60, 80, 100], [10, 20, 30, 40, 50],[250, 500, 750, 1000, 1250]]
xLabels = ['Number of Nodes', 'Number of Flows']
yLabels = ['Network Throughput(kbit/s)', 'End to End Delay(s)', 'Delivery Ratio', 'Drop Ratio']
xLabelIndex = int(sys.argv[3])
def plot(figsize,x,y,label,xLabel, yLabel,saveFile):
    plt.figure(figsize=figsize)
    plt.plot(x,y, marker = 'o', linestyle = '--', color = 'blue',label = label)
    plt.axhline(linewidth=1, color='green')
    plt.xlabel(xLabel)
    plt.ylabel(yLabel)
    plt.legend()
    plt.grid()
    plt.savefig(saveFile)
    # plt.show()

throughputs = []
e2es = []
deliveryRs = []
dropRs = []

for i in range(1, 3):
    with open(sys.argv[i]) as tcp_params:
        throughput = []
        e2e = []
        deliveryR = []
        dropR = []
        while True:
            line = tcp_params.readline()
            if not line:
                break
            words = line.split()
            for i in range(0, len(words)):
                words[i] = float(words[i])
            throughput.append(words[0])
            e2e.append(words[1])
            deliveryR.append(words[2])
            dropR.append(words[3])

        throughputs.append(throughput)
        e2es.append(e2e)
        deliveryRs.append(deliveryR)
        dropRs.append(dropR)

# print(throughputs)
# print(dropRs)

def computeDiff(arr):
    return [((arr[1][i] - arr[0][i]) / arr[0][i]) * 100 for i in range(0,len(arr[0]))]

throughputsDiff = computeDiff(throughputs)
e2esDiff = computeDiff(e2es)
deliveryRsDiff = computeDiff(deliveryRs)
dropRsDiff = computeDiff(dropRs)

xLabel = xLabels[xLabelIndex]
x = xs[xLabelIndex]
def plot2(arr, i):
    plot((8,4), x,arr,yLabels[i] + " vs " +xLabel,xLabel,yLabels[i],sys.argv[4] + str(i) + ".png")

plot2(throughputsDiff, 0)
plot2(e2esDiff, 1)
plot2(deliveryRsDiff, 2)
plot2(dropRsDiff, 3)


# print(throughputsDiff, e2esDiff, deliveryRsDiff, dropRsDiff)
# for j in range(2,3):

    
#     throughput = []
#     delay = []
#     deliveryRatio = []
#     dropRatio = []

#     for i in range(5):
#         line = input()
#         words = line.split(" ")
#         throughput.append(float(words[0]) / 1000)
#         delay.append(float(words[1]))
#         deliveryRatio.append(float(words[2]))
#         dropRatio.append(float(words[3]))
        



#     plot((8, 4), x[j],throughput, 'Network Throughput(kbit/s) vs ' + xLabels[j],xLabels[j],'Network Throughput(kbit/s)','./plots/' + str(j) + '-t.png')
#     plot((8, 4), x[j], delay, 'End to End Delay(s) vs ' + xLabels[j],xLabels[j] ,'End to End Delay(s)','./plots/' + str(j) + '-e.png')
#     plot((8, 4), x[j],deliveryRatio,   'Delivery Ratio vs ' +  xLabels[j],xLabels[j] ,'Delivery Ratio','./plots/' + str(j) + '-dlR.png')
#     plot((8, 4), x[j],dropRatio, 'Drop Ratio vs ' +  xLabels[j],xLabels[j],'Drop Ratio','./plots/' + str(j) + '-drR.png')




# plt.figure(figsize=(12, 5))
# plt.plot(areas, throughput, marker = 'o', linestyle = '--', color = 'blue',label = 'Area Size(m) vs Network Throughput(kbit/s)')
# plt.xlabel('Area Size(m)')
# plt.ylabel('Network Throughput(kbit/s)')
# plt.legend()
# plt.grid()
# plt.savefig('test.png')
# plt.show()
