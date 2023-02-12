#!/bin/bash
# bd=20mb
main="./stats/wired/flows"
python3 reducer.py $main/stats-fit.txt > $main/stats-fit-reduced.txt
main="./stats/wired/nodes"
python3 reducer.py $main/stats-fit.txt > $main/stats-fit-reduced.txt
main="./stats/wired/packetRate"
python3 reducer.py $main/stats-fit.txt > $main/stats-fit-reduced.txt
