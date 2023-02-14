#!/bin/bash

# params
bd=500mb
bn=2
f=1
drRate=.05
nodes=1
area=5000

main="./stats/wired_wireless_extra"
srcFile=wired_wireless_extra.tcl
trFile=traceWiredWirelessDr.tr
namFile=namWiredWirelessDr.nam
area=1400
drRate=.1



oneIteration(){
    # echo "nodes: $1 flows: $2 bandwidth: $3"
    echo "area:$1 drop rate: $2 delay: $3"
    ns $srcFile $nodes $nodes $bn $f $1 0 _ _ $bd $2 $trFile $namFile $3 1>  "$root/wired_output_tcp.txt" 2> "$root/wired_output_tcp_errs.txt"
    echo "tcp simulation done"
    ./parser < $trFile >> "$root/stats-tcp.txt"
    echo "tcp parsing done"
    for N in 1 2 4 8 16
    do
        for alpha in .1 .3 .5 .7 .9
        do
            echo "N: $N alpha: $alpha"
            ns $srcFile  $nodes $nodes $bn $f $1 1 $N $alpha $bd $2 $trFile $namFile $3 1>  "$root/wired_output_fit.txt" 2> "$root/wired_output_fit_errs.txt"
            echo "tcp fit simulation done"
            ./parser < $trFile | python3 test.py "$root/stats-tcp.txt" >>  "$root/stats-fit.txt"
            echo "tcp fit parsing done"

        done
    done
    echo "" >> "$root/stats-fit.txt"
}


# echo "################################## drop rates #######################################"
# root="$main/drop_rates"
# mkdir -p $root
# >"$root/stats-tcp.txt"
# >"$root/stats-fit.txt"

# for drRate in .05 .1 .15 .2 .25
# do
#     oneIteration $area $drRate 500ms
# done


echo "################################## delays #######################################"

root="$main/delays"
mkdir -p $root
>"$root/stats-tcp.txt"
>"$root/stats-fit.txt"


declare -a areas=(600 800 1000 1200 1400)
declare -a delays=(100ms 200ms 300ms 400ms 500ms)

for dr in .01 .03 .05 .07
do
    root="$main/delays/dr-$dr"
    mkdir -p $root
    >"$root/stats-tcp.txt"
    >"$root/stats-fit.txt"
    for i in 0 1 2 3 4 
    do
        oneIteration ${areas[$i]} $dr ${delays[$i]}
    done
done
# 1400 - 500
# 1200 - 400
# 1000 - 300
# 800  - 200
# 600  - 100
# ns wired_wireless_extra.tcl 1 1 2 1 1400 0 1 .5 100mb .01 test.tr test.nam 400ms 
# ns wired_wireless_extra.tcl 1 1 2 1 600 0 1 .5 100mb .01 test.tr test.nam 100ms 
