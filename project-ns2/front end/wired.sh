#!/bin/bash

bd=300
bn=2
f=40
drRate=.0001
trFile=traceWired.tr
nodes=20


main="./stats/wired/"


root="$main/packetRate"
mkdir -p $root
>"$root/stats-tcp.txt"
>"$root/stats-fit.txt"

for prate in  100 200 300 400 500
do
    ns wired.tcl $nodes $nodes $bn $f _ 0 _ _ $prate $drRate >  "$root/wired_output_tcp.txt"
    ./parser < $trFile >> "$root/stats-tcp.txt"
    for N in 1 2 4 8 16
    do
        for alpha in .1 .3 .5 .7 .9
        do
            ns wired.tcl  $nodes $nodes $bn $f _ 1 $N $alpha $prate $drRate >  "$root/wired_output_fit.txt"
            ./parser < $trFile | python3 test.py "$root/stats-tcp.txt" >>  "$root/stats-fit.txt"
        done
    done
    echo "" >> "$root/stats-fit.txt"
done



root="$main/nodes"
mkdir -p $root
>"$root/stats-tcp.txt"
>"$root/stats-fit.txt"

for n in  10 20 30 40 50
do
    ns wired.tcl $n $n $bn $f _ 0 _ _ $bd $drRate >  "$root/wired_output_tcp.txt"
    ./parser < $trFile >> "$root/stats-tcp.txt"
    for N in 1 2 4 8 16
    do
        for alpha in .1 .3 .5 .7 .9
        do
            ns wired.tcl  $n $n $bn $f _ 1 $N $alpha $bd $drRate >  "$root/wired_output_fit.txt"
            ./parser < $trFile | python3 test.py "$root/stats-tcp.txt" >>  "$root/stats-fit.txt"
        done
    done
    echo "" >> "$root/stats-fit.txt"
done


root="$main/flows"
mkdir -p $root
>"$root/stats-tcp.txt"
>"$root/stats-fit.txt"

for flows in 10 20 30 40 50
do
    ns wired.tcl $nodes $nodes $bn $flows _ 0 _ _ $bd $drRate >  "$root/wired_output_tcp.txt"
    ./parser < $trFile >> "$root/stats-tcp.txt"

    for N in 1 2 4 8 
    do
        for alpha in .1 .3 .5 .7 
        do
            ns wired.tcl  $nodes $nodes $bn $flows _ 1 $N $alpha $bd $drRate >  "$root/wired_output_fit.txt"
            ./parser < $trFile | python3 test.py "$root/stats-tcp.txt" >>  "$root/stats-fit.txt"
        done
    done
    echo "" >> "$root/stats-fit.txt"
done





# ns wireless.tcl 30 30 4 30 5000 1 1 .5 100mb > -.txt
# ns wireless.tcl 10 10 2 0 5000 1 1 .5 100mb > -.txt
# ns wire_wireless2.tcl 10 10 2 0 5000 1 1 .5 100mb 
# ns wire_wireless2.tcl 5 5 2 4 600 0 1 .5 1mb

# 332117.423689 0.747421 0.988994 0.007154 

# ns wired.tcl 30 30 4 30 5000 1 1 .5 100mb