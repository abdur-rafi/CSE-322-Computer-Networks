#!/bin/bash

# params
bd=50mb
bn=2
f=40
drRate=.05
nodes=20
area=5000
repeat=25
speed=15
if [[ $1 == 0 ]];then
    main="./stats/average/wired"
    srcFile=wired.tcl
    trFile=traceWired.tr
    namFile=namWired.nam
elif [[ $1 == 1 ]]; then

    main="./stats/average/wireLess_bn_2_25"
    srcFile=wireless.tcl
    trFile=traceWireless.tr
    namFile=namWireless.nam
    bn=2
    drRate=.05
    area=600
else

    main="./stats/average/wired_wireless_dr07"
    srcFile=wired_wireless.tcl
    trFile=traceWiredWireless.tr
    namFile=namWiredWireless.nam
    area=1500
    drRate=.07
fi
# ns wireless.tcl 20 20 3 40 5000 1 1 .7 50mb .05 test.tr test.nam
# ns wired_wireless.tcl 10 10 2 10 650 0 1 .5 10mb .1 test.tr test.nam
# arguments : nodes, flow, bandwidth
oneIteration(){
    echo "nodes: $1 flows: $2 bandwidth: $3 speed: $4"
    i=0
    while (( $i < $repeat ))
    do
        echo $i
        ns $srcFile $1 $1 $bn $2 $area 0 _ _ $3 $drRate $trFile $namFile $4 1>  "$root/wired_output_tcp.txt" 2> "$root/wired_output_tcp_errs.txt"
        ./parser < $trFile >> "$root/stats-tcp.txt"
        ((i++))
    done
    echo "tcp done"
    echo "" >> "$root/stats-tcp.txt"
    for N in 1 2 4 8 16
    do
        for alpha in .1 .3 .5 .7 .9 
        do
            echo "N: $N alpha: $alpha"
            ns $srcFile  $1 $1 $bn $2 $area 1 $N $alpha $3 $drRate $trFile $namFile $4 1>  "$root/wired_output_fit.txt" 2> "$root/wired_output_fit_errs.txt"
            echo "tcp fit simulation done"
            ./parser < $trFile  >>  "$root/stats-fit.txt"
            echo "tcp fit parsing done"

        done
    done
    echo "" >> "$root/stats-fit.txt"
    # python3 reducer.py $root/stats-fit.txt > $root/stats-fit-reduced.txt
}


echo "################################## nodes #######################################"
root="$main/nodes"
mkdir -p $root
>"$root/stats-tcp.txt"
>"$root/stats-fit.txt"


for n in  10 20 30 40 50
do
    oneIteration $n $f $bd $speed
done

echo "################################## flows #######################################"

root="$main/flows"
mkdir -p $root
>"$root/stats-tcp.txt"
>"$root/stats-fit.txt"

for flows in 10 20 30 40 50
do
    oneIteration $nodes $flows $bd $speed
done




echo "################################### packet rate #################################"

root="$main/packetRate"
mkdir -p $root
>"$root/stats-tcp.txt"
>"$root/stats-fit.txt"

for prate in  20mb 40mb 60mb 80mb 100mb
do
    oneIteration $nodes $f $prate $speed
done

if [[ $1 != 0 ]]; then
    echo "################################### speed #####################################"

    root="$main/speed"
    mkdir -p $root
    >"$root/stats-tcp.txt"
    >"$root/stats-fit.txt"

    for s in  5 10 15 20 25
    do
        oneIteration $nodes $f $prate $s
    done


fi




# ns wireless.tcl 30 30 4 30 5000 1 1 .5 100mb > -.txt
# ns wireless.tcl 10 10 2 0 5000 1 1 .5 100mb > -.txt
# ns wire_wireless2.tcl 10 10 2 0 5000 1 1 .5 100mb 
# ns wire_wireless2.tcl 5 5 2 4 600 0 1 .5 1mb

# 332117.423689 0.747421 0.988994 0.007154 

# ns wired.tcl 30 30 4 30 5000 1 1 .5 100mb
# ns wireless.tcl 30 30 4 30 5000 0 1 .5 10mb .05 test.tr test.nam
#  ns wireless.tcl 10 10 3 10 5000 0 1 .5 10mb .001

# ns wireless.tcl 30 30 3 30 800 0 1 .5 10mb .05 test.tr test.nam 10
# ns wireless.tcl 30 30 2 30 600 0 1 .5 10mb .05 test.tr test.nam 10

# ns wired_wireless.tcl 30 30 2 30 1400 0 1 .5 10mb .05 test.tr test.nam 10
# ns wired_wireless.tcl 30 30 2 30 1400 0 1 .5 10mb .05 test.tr test.nam 10
# ns wired_wireless.tcl 30 30 2 30 1800 0 1 .5 10mb .05 test.tr test.nam 10
# ns wireless.tcl 10 10 3 10 800 0 1 .5 10mb .05 test.tr test.nam 10
# ns wired_wireless.tcl 10 10 2 10 1800 0 1 .5 10mb .05 test.tr test.nam 10

ns wired_wireless_wireless_link.tcl 10 10 2 10 1000 0 1 .5 10mb .05 test.tr test.nam 10