import matplotlib.pyplot as plt
import sys

x_label = sys.argv[1]
x_ticks = sys.argv[2:7]
save_dir = sys.argv[7]

def plot(figsize,x,y,label,xLabel, yLabel,saveFile):
    plt.figure(figsize=figsize)
    diff = []
    for i in range(len(y[0])):
        diff.append(((y[1][i] - y[0][i])/ y[0][i]) * 100)
    plt.plot(x,diff, marker = 'o', linestyle = '--', color = 'orange',label = "TCP-Fit Improvement")
    # plt.plot(x,y[1], marker = 'x', linestyle = '--', color = 'red',label="TCP-Fit")

    plt.xlabel(xLabel)
    plt.ylabel(yLabel)
    plt.title(label, size = 11)
    plt.legend()
    plt.grid()
    plt.savefig(saveFile)
    # plt.show()



    
throughput = [[], []]
delay = [[], []]
deliveryRatio = [[], []]
dropRatio = [[], []]
energy = [[], []]
for j in range(2):
    for i in range(5):
        line = input()
        words = line.split(" ")
        words = words[0:-1]
        throughput[j].append(float(words[0]) / 1000)
        delay[j].append(float(words[1]))
        deliveryRatio[j].append(float(words[2]))
        dropRatio[j].append(float(words[3]))
        if len(words) > 4:
            energy[j].append(float(words[4]))
        else:
            energy[j].append(0.0)

    


figsz = (8,4)

plot(figsz, x_ticks,throughput, 'Network Throughput Improvement(%) vs ' + x_label,x_label,'Network Throughput Improvement(%)',save_dir + '/throuhgput.png')
plot(figsz, x_ticks, delay, 'End to End Delay Increase(%) vs ' + x_label,x_label ,'End to End Delay Increase(%)',save_dir + '/end2endDelay.png')
plot(figsz, x_ticks,deliveryRatio,   'Delivery Ratio Improvement(%) vs ' +  x_label,x_label ,'Delivery Ratio Improvement(%)',save_dir + '/deliveryRatio.png')
plot(figsz, x_ticks,dropRatio, 'Drop Ratio Increase(%) vs ' +  x_label,x_label,'Drop Ratio Increase(%)',save_dir + '/dropRatio.png')
plot(figsz, x_ticks,energy, 'Energy Per Received Packet Improvement(%) vs ' +  x_label,x_label,'Energy Per Received Packet Improvement(%)',save_dir + '/energy.png')




# plt.figure(figsize=(12, 5))
# plt.plot(areas, throughput, marker = 'o', linestyle = '--', color = 'blue',label = 'Area Size(m) vs Network Throughput(kbit/s)')
# plt.xlabel('Area Size(m)')
# plt.ylabel('Network Throughput(kbit/s)')
# plt.legend()
# plt.grid()
# plt.savefig('test.png')
# plt.show()
