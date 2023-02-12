#!/bin/bash

for i in `ls $1`
do
    # echo $i
    index=0
    for j in `ls $1/$i/`
    do
        # echo $j
        python3 plotterdiff.py "$1/$i/$j/stats-tcp.txt" "$1/$i/$j/stats-fit.txt" $index "$1/$i/$j/"
        index=$(( index + 1 ))
    done
done