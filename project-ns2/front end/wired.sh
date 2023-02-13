#!/bin/bash

# params
bd=50mb
bn=2
f=40
drRate=.05
nodes=20
area=5000
if [[ $1 == 0 ]];then
    main="./stats/wired-2"
    srcFile=wired.tcl
    trFile=traceWired.tr
    namFile=namWired.nam
elif [[ $1 == 1 ]]; then

    main="./stats/wireLess_bn_3"
    srcFile=wireless.tcl
    trFile=traceWireless.tr
    namFile=namWireless.nam
    bn=3
    drRate=.05
else

    main="./stats/wired_wireless_dr10"
    srcFile=wired_wireless.tcl
    trFile=traceWiredWireless.tr
    namFile=namWiredWireless.nam
    area=1400
    drRate=.1
fi
# ns wireless.tcl 20 20 3 40 5000 0 1 .5 10mb .1 test.tr test.nam
# ns wired_wireless.tcl 10 10 2 10 650 0 1 .5 10mb .1 test.tr test.nam
# arguments : nodes, flow, bandwidth
oneIteration(){

    ns $srcFile $1 $1 $bn $2 $area 0 _ _ $3 $drRate $trFile $namFile >  "$root/wired_output_tcp.txt"
    ./parser < $trFile >> "$root/stats-tcp.txt"
    for N in 1 2 4 8 16
    do
        for alpha in .1 .3 .5 .7 .9
        do
            ns $srcFile  $1 $1 $bn $2 $area 1 $N $alpha $3 $drRate $trFile $namFile >  "$root/wired_output_fit.txt"
            ./parser < $trFile | python3 test.py "$root/stats-tcp.txt" >>  "$root/stats-fit.txt"
        done
    done
    echo "" >> "$root/stats-fit.txt"
    # python3 reducer.py $root/stats-fit.txt > $root/stats-fit-reduced.txt
}


root="$main/packetRate"
mkdir -p $root
>"$root/stats-tcp.txt"
>"$root/stats-fit.txt"

for prate in  20mb 40mb 60mb 80mb 100mb
do
    oneIteration $nodes $f $prate
done



root="$main/nodes"
mkdir -p $root
>"$root/stats-tcp.txt"
>"$root/stats-fit.txt"


for n in  10 20 30 40 50
do
    oneIteration $n $f $bd
done


root="$main/flows"
mkdir -p $root
>"$root/stats-tcp.txt"
>"$root/stats-fit.txt"

for flows in 10 20 30 40 50
do
    oneIteration $nodes $flows $bd
done





# ns wireless.tcl 30 30 4 30 5000 1 1 .5 100mb > -.txt
# ns wireless.tcl 10 10 2 0 5000 1 1 .5 100mb > -.txt
# ns wire_wireless2.tcl 10 10 2 0 5000 1 1 .5 100mb 
# ns wire_wireless2.tcl 5 5 2 4 600 0 1 .5 1mb

# 332117.423689 0.747421 0.988994 0.007154 

# ns wired.tcl 30 30 4 30 5000 1 1 .5 100mb
# ns wireless.tcl 30 30 4 30 5000 0 1 .5 10mb .05 test.tr test.nam
#  ns wireless.tcl 10 10 3 10 5000 0 1 .5 10mb .001