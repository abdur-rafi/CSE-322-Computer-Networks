#!/bin/bash

# params
bd=200mb
bn=2
f=2
drRate=.05
nodes=2
area=1500
speed=5
N=1
alpha=.7
srcFile=wired_wireless_fairness.tcl
trFile=traceWiredWirelessFairness.tr
namFile=namWiredWirelessFairness.nam

main="./stats/fairness"
root="$main"
mkdir -p $root
>"$root/stats-tcp.txt"
>"$root/stats-fit.txt"
ns $srcFile $nodes $nodes $bn $f $area 0 $N  $alpha $bd $drRate $trFile $namFile $speed 1>  "$root/wired_output_tcp.txt" 2> "$root/wired_output_tcp_errs.txt"
