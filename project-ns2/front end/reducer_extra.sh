#!/bin/bash
# bd=20mb
root="./stats/wired_wireless_extra"
# main="$root/drop_rates"
# python3 reducer.py $main/stats-fit.txt > $main/stats-fit-reduced.txt
# main="$root/nodes"
# python3 reducer.py $main/stats-fit.txt > $main/stats-fit-reduced.txt
# main="$root/packetRate"
# python3 reducer.py $main/stats-fit.txt > $main/stats-fit-reduced.txt
main="$root/delays/dr-.01"
python3 reducer.py $main/stats-fit.txt > $main/stats-fit-reduced.txt
main="$root/delays/dr-.03"
python3 reducer.py $main/stats-fit.txt > $main/stats-fit-reduced.txt
main="$root/delays/dr-.05"
python3 reducer.py $main/stats-fit.txt > $main/stats-fit-reduced.txt
main="$root/delays/dr-.07"
python3 reducer.py $main/stats-fit.txt > $main/stats-fit-reduced.txt
