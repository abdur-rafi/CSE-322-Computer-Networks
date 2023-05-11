namespace import ::tcl::mathfunc::*

set N1 [lindex $argv 0]
set N2 [lindex $argv 1]
set B [lindex $argv 2]
set F [lindex $argv 3]
set X [lindex $argv 4]
set useFit [lindex $argv 5]
set N [lindex $argv 6]
set alpha [lindex $argv 7]
set bandwidth [lindex $argv 8]
set dropRate [lindex $argv 9]
set traceFile [lindex $argv 10]
set namTraceFile [lindex $argv 11]
set speed [lindex $argv 12]

set Y $X

set stopTime 40
set startTime 10

set ns [new Simulator]

$ns use-newtrace

set traceFile [open $traceFile w]
set namTraceFile [open $namTraceFile w]

$ns trace-all $traceFile
$ns namtrace-all-wireless $namTraceFile $X $Y 

set topo [new Topography]
$topo load_flatgrid $X $Y

create-god [expr $N1 + $N2]
set N [expr $N1 + $N2]

set channel [new Channel/WirelessChannel]

# expr { srand(19) }

# CMUPriQueue
# Queue/DropTail/PriQueue
$ns node-config -adhocRouting DSR \
    -llType LL \
    -macType Mac/802_11 \
    -ifqType CMUPriQueue \
    -ifqLen 50 \
    -energyModel "EnergyModel" \
    -initialEnergy 100.0 \
    -txPower .4 \
    -rxPower .3 \
    -idlePower 0.1 \
    -sleepPower .01 \
    -antType Antenna/OmniAntenna \
    -propType Propagation/TwoRayGround \
    -phyType Phy/WirelessPhy \
    -channel $channel\
    -topoInstance $topo \
    -agentTrace ON \
    -routerTrace ON \
    -macTrace OFF \
    -movementTrace OFF		

for {set i 0} {$i < $N} {incr i} {
    set nodes($i) [$ns node]
    $nodes($i) random-motion 1
}

set colCount [ round [ceil [sqrt $N]]]
set gap [expr $X / $colCount]
for {set i 0} {$i < $N} {incr i} {
    $nodes($i) set X_ [expr [round [expr $i / $colCount]] * $gap]
    $nodes($i) set Y_ [expr [round [expr $i % $colCount]] * $gap]
    $nodes($i) set Z_ 0.0
    $ns initial_node_pos $nodes($i) 10
    $nodes($i) random-motion 1
    $ns at 0.0 "$nodes($i) setdest [expr rand() * $X] [expr [rand] * $Y] [expr 1 + [rand] * $speed]"
    for {set j 0} {$j < 10} {incr j} {
        $ns at [ expr $stopTime /  (10-$j) ] "$nodes($i) setdest [expr rand() * $X] [expr [rand] * $Y] [expr 1 + [rand] * $speed]"        
    }

}


for {set i 0} {$i < $F} {incr i} {
    if {$useFit == "1"} {
        set agents($i) [new Agent/TCP/FitW]
        $agents($i) set N $N
        $agents($i) set alpha $alpha
    } else {
        set agents($i) [new Agent/TCP]
    }

    set traffic($i) [new Application/Traffic/Exponential]
    
    $traffic($i) set packetSize_ 200
    # $traffic($i) set interval_ 0.005
	
    $traffic($i) set packetSize_ 200
    $traffic($i) set burst_time_ 1s
    $traffic($i) set idle_time_ 10ms
    $traffic($i) set rate_ $bandwidth

    set null [new Agent/TCPSink]


    set src [round [floor [expr [rand] * $N]]]
    set dest [round [floor [expr [rand] * $N]]]

    while {$src == $dest} {
        set dest [round [floor [expr [rand] * $N]]]
    }

    $ns attach-agent $nodes($src) $agents($i)
    $traffic($i) attach-agent $agents($i)


    # puts $src 
    # puts $dest

    $ns attach-agent $nodes($dest) $null
    $ns connect $agents($i) $null
    $ns at $startTime "$traffic($i) start"   
    $ns at $stopTime "$traffic($i) stop"

}

proc stop {} {
    global ns traceFile namTraceFile
    $ns flush-trace
    close $traceFile
	close $namTraceFile
    exit 0
    # exec nam offline.nam
}


# for {set i 0} {$i < $N} {incr i} {
#     $ns at 0.1 "$traffic($i) start"   
#     $ns at $stopTime "$traffic($i) stop"
# }

for {set i 0} {$i < $N} {incr i} {
    $ns at 0.0 "$nodes($i) setdest [expr [rand] * $X] [expr [rand] * $Y] [expr 1 + [rand] * 4]"
    $ns at [ expr $stopTime / 4] "$nodes($i) setdest [expr [rand] * $X] [expr [rand] * $Y] [expr 1 + [rand] * 4]"
    $ns at [ expr $stopTime / 2] "$nodes($i) setdest [expr [rand] * $X] [expr [rand] * $Y] [expr 1 + [rand] * 4]"
    $ns at [ expr 3 * $stopTime / 4] "$nodes($i) setdest [expr [rand] * $X] [expr [rand] * $Y] [expr 1 + [rand] * 4]"


}



$ns at [expr $stopTime + 1] "stop"

$ns run