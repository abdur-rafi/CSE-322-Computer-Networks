import matplotlib.pyplot as plt

x = [[250, 500, 750, 1000, 1250], [20, 40, 60, 80, 100], [10, 20, 30, 40, 50]]
xLabels = ['Area Size(m)', 'Number of Nodes', 'Number of Flows']


def plot(figsize,x,y,label,xLabel, yLabel,saveFile):
    plt.figure(figsize=figsize)
    plt.plot(x,y, marker = 'o', linestyle = '--', color = 'blue',label = label)
    plt.xlabel(xLabel)
    plt.ylabel(yLabel)
    plt.legend()
    plt.grid()
    plt.savefig(saveFile)
    # plt.show()


for j in range(2,3):

    
    throughput = []
    delay = []
    deliveryRatio = []
    dropRatio = []

    for i in range(5):
        line = input()
        words = line.split(" ")
        throughput.append(float(words[0]) / 1000)
        delay.append(float(words[1]))
        deliveryRatio.append(float(words[2]))
        dropRatio.append(float(words[3]))
        



    plot((8, 4), x[j],throughput, 'Network Throughput(kbit/s) vs ' + xLabels[j],xLabels[j],'Network Throughput(kbit/s)','./plots/' + str(j) + '-t.png')
    plot((8, 4), x[j], delay, 'End to End Delay(s) vs ' + xLabels[j],xLabels[j] ,'End to End Delay(s)','./plots/' + str(j) + '-e.png')
    plot((8, 4), x[j],deliveryRatio,   'Delivery Ratio vs ' +  xLabels[j],xLabels[j] ,'Delivery Ratio','./plots/' + str(j) + '-dlR.png')
    plot((8, 4), x[j],dropRatio, 'Drop Ratio vs ' +  xLabels[j],xLabels[j],'Drop Ratio','./plots/' + str(j) + '-drR.png')




# plt.figure(figsize=(12, 5))
# plt.plot(areas, throughput, marker = 'o', linestyle = '--', color = 'blue',label = 'Area Size(m) vs Network Throughput(kbit/s)')
# plt.xlabel('Area Size(m)')
# plt.ylabel('Network Throughput(kbit/s)')
# plt.legend()
# plt.grid()
# plt.savefig('test.png')
# plt.show()
