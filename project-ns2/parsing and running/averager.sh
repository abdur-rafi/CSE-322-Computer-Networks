#!/bin/bash
# bd=20mb
file=averager.py
root="./stats/average/wireLess_rand_2"
oneItr(){
    python3 $file $main/stats-fit.txt > $main/stats-fit-averaged.txt
    python3 $file $main/stats-tcp.txt > $main/stats-tcp-averaged.txt

}
main="$root/nodes"
oneItr
main="$root/flows"
oneItr
main="$root/packetRate"
oneItr
main="$root/speed"
oneItr
