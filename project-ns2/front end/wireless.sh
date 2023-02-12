#!/bin/bash

bd=100mb
bn=10
f=40
N=4
alpha=.7
area=5000
for bd in 100mb 200mb 10mb  
do
main="./wireless/$bd"
    for N in 4 8 16
    do

        for alpha in  .3 .5 .7 
        do


            mkdir -p "$main/$N-$alpha/nodes"
            root="$main/$N-$alpha/nodes/"

            >"$root/stats-tcp.txt"
            >"$root/stats-fit.txt"

            for nodes in 10 20 30 40 50
            do
                ns wireless.tcl $nodes $nodes $bn $f $area 0 _ _ $bd >  "$root/wired_output_tcp.txt"
                ./parser < traceWireless.tr >> "$root/stats-tcp.txt"

                ns wireless.tcl  $nodes $nodes $bn $f $area 1 $N $alpha $bd >  "$root/wired_output_fit.txt"
                ./parser < traceWireless.tr >> "$root/stats-fit.txt"
            done


            mkdir -p "$main/$N-$alpha/flows"
            root="$main/$N-$alpha/flows"

            >"$root/stats-tcp.txt"
            >"$root/stats-fit.txt"


            for flows in 10 20 30 40 50
            do
                ns wireless.tcl 20 20 $bn $flows $area 0 _ _ $bd >  "$root/wired_output_tcp.txt"
                ./parser < traceWireless.tr >> "$root/stats-tcp.txt"


                ns wireless.tcl  20 20 $bn $flows $area 1 $N $alpha $bd >  "$root/wired_output_fit.txt"
                ./parser < traceWireless.tr >> "$root/stats-fit.txt"
            done
        done

    done
done
# ns wireless.tcl 30 30 4 30 5000 1 1 .5 100mb > -.txt
