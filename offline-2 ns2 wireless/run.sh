#!/bin/bash

>stats.txt
for area in 250 500 750 1000 1250
do
    ns offline.tcl 40 20 $area
    python3 parser_1.py >> stats.txt
done

for node in 20 40 60 80 100
do
    ns offline.tcl $node 20 500
    python3 parser_1.py >> stats.txt
done

for flow in 10 20 30 40 50
do
    ns offline.tcl 40 $flow 500
    python3 parser_1.py >> stats.txt
done
