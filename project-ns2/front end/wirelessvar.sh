#!/bin/bash

bd=200mb
bn=2
f=50
N=4
alpha=.7
area=5000
for bd in 40mb
do
    main="./wireless/randomReno/$bd"
    
    root="$main/nodes"
    mkdir -p $root
    >"$root/stats-tcp.txt"
    >"$root/stats-fit.txt"

    for nodes in  10 20 30 40 50
    do
        ns wireless.tcl $nodes $nodes $bn $f $area 0 _ _ $bd >  "$root/wired_output_tcp.txt"
        ./parser < traceWireless.tr >> "$root/stats-tcp.txt"
        for N in 1 2 4 8 
        do
            for alpha in .1 .3 .5 .7 
            do
                ns wireless.tcl  $nodes $nodes $bn $f $area 1 $N $alpha $bd >  "$root/wired_output_fit.txt"
                ./parser < traceWireless.tr | python3 test.py "$root/stats-tcp.txt" >>  "$root/stats-fit.txt"
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
        ns wireless.tcl 20 20 $bn $flows $area 0 _ _ $bd >  "$root/wired_output_tcp.txt"
        ./parser < traceWireless.tr >> "$root/stats-tcp.txt"

        for N in 1 2 4 8 
        do
            for alpha in .1 .3 .5 .7 
            do
                ns wireless.tcl  $nodes $nodes $bn $f $area 1 $N $alpha $bd >  "$root/wired_output_fit.txt"
                ./parser < traceWireless.tr | python3 test.py "$root/stats-tcp.txt" >>  "$root/stats-fit.txt"
            done
        done
        echo "" >> "$root/stats-fit.txt"
    done
done

# ns wireless.tcl 30 30 4 30 5000 1 1 .5 100mb > -.txt
# ns wireless.tcl 10 10 2 0 5000 1 1 .5 100mb > -.txt
# ns wire_wireless2.tcl 10 10 2 0 5000 1 1 .5 100mb 
# ns wire_wireless2.tcl 5 5 2 4 600 0 1 .5 1mb

# 332117.423689 0.747421 0.988994 0.007154 

# ns wired.tcl 30 30 4 30 5000 1 1 .5 100mb