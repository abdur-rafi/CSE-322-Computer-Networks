import matplotlib.pyplot as plt
import sys

x_label = sys.argv[1]
x_ticks = sys.argv[2:7]
save_dir = sys.argv[7]

def plot(figsize,x,y,label,xLabel, yLabel,saveFile):
    plt.figure(figsize=figsize)
    plt.plot(x,y, marker = 'o', linestyle = '--', color = 'blue',label = label)
    plt.xlabel(xLabel)
    plt.ylabel(yLabel)
    plt.legend()
    plt.grid()
    plt.savefig(saveFile)
    # plt.show()



    
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
    



plot((8, 4), x_ticks,throughput, 'Network Throughput(kbit/s) vs ' + x_label,x_label,'Network Throughput(kbit/s)',save_dir + '/throuhgput.png')
plot((8, 4), x_ticks, delay, 'End to End Delay(s) vs ' + x_label,x_label ,'End to End Delay(s)',save_dir + '/end2endDelay.png')
plot((8, 4), x_ticks,deliveryRatio,   'Delivery Ratio vs ' +  x_label,x_label ,'Delivery Ratio',save_dir + '/deliveryRatio.png')
plot((8, 4), x_ticks,dropRatio, 'Drop Ratio vs ' +  x_label,x_label,'Drop Ratio',save_dir + '/dropRatio.png')




# plt.figure(figsize=(12, 5))
# plt.plot(areas, throughput, marker = 'o', linestyle = '--', color = 'blue',label = 'Area Size(m) vs Network Throughput(kbit/s)')
# plt.xlabel('Area Size(m)')
# plt.ylabel('Network Throughput(kbit/s)')
# plt.legend()
# plt.grid()
# plt.savefig('test.png')
# plt.show()
