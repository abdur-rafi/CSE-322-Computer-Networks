#!/bin/bash
plotterFile=plotter2.py
plotOneDir(){
    echo "dir: $1 saveDir : $2 file: $3"
    curr=$1/nodes
    saveFileDir=$2/nodes
    mkdir -p $saveFileDir
    cat $curr/$3 $curr/$4 | python3 $plotterFile nodes 20 40 60 80 100 $saveFileDir
    
    curr=$1/flows
    saveFileDir=$2/flows
    mkdir -p $saveFileDir
    cat $curr/$3 $curr/$4 | python3 $plotterFile flows 10 20 30 40 50 $saveFileDir 

    curr=$1/packetRate
    saveFileDir=$2/packetRate
    mkdir -p $saveFileDir
    cat $curr/$3 $curr/$4 | python3 $plotterFile "Packet Rate" 20mb 40mb 60mb 80mb 100mb $saveFileDir 
}

rootDir=$1
saveDir=$2
file1=$3
file2=$4
plotOneDir $rootDir $saveDir $file1 $file2