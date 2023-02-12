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

set stopTime 20
set radius 200
set bottleNeckXOffset 300
set bottleNeckYOffset 300
set bottleNeckGap 250
set Y [expr 2 * $radius + 10]

set ns [new Simulator]

$ns use-newtrace

set traceFile [open traceWireless.tr w]
set namTraceFile [open namWireless.nam w]

$ns trace-all $traceFile
$ns namtrace-all-wireless $namTraceFile $X $Y 

set topo [new Topography]
$topo load_flatgrid $X $Y

create-god [expr $N1 + $N2 + $B]

set channel [new Channel/WirelessChannel]
expr { srand(19) }

# set q [new Queue/DropTailRand]
# $q set seed 123
# $q set drop_probability 5

Queue/DropTail set seed 123
Queue/DropTail set drop_probability 5

# Queue/DropTailRand2 set prob 0

LL set delay_ 200ms

$ns node-config -adhocRouting AODV \
    -llType LL \
    -macType Mac/802_11 \
    -ifqType Queue/DropTail \
    -ifqLen 50 \
    -antType Antenna/OmniAntenna \
    -propType Propagation/TwoRayGround \
    -phyType Phy/WirelessPhy \
    -channel $channel\
    -topoInstance $topo \
    -agentTrace ON \
    -routerTrace ON \
    -macTrace OFF \
    -movementTrace OFF		
# $ns node-config -ifqType Queue/DropTail

for {set i 0} {$i < $B} {incr i} {
    set bottleNeckNodes($i) [$ns node]
    $bottleNeckNodes($i) set X_ [expr $bottleNeckXOffset + $i * $bottleNeckGap]
    $bottleNeckNodes($i) set Y_ [expr $bottleNeckYOffset  ]
    $bottleNeckNodes($i) set Z_ 0.0
    $ns initial_node_pos $bottleNeckNodes($i) 10
    $ns at $stopTime "$bottleNeckNodes($i) reset"

}
Queue/DropTail set drop_probability 0
LL set delay_ 20ms

set angleOffset .3

for {set i 0} {$i < $N1} {incr i} {
    set srcNodes($i) [$ns node]
    set angle [expr ((3.1416 - 2 * $angleOffset ) / ($N1 - 1)) * $i]
    set yOffset [expr $radius * cos($angle + $angleOffset )]
    set xOffset [expr $radius * sin($angle + $angleOffset )]
    $srcNodes($i) set X_ [expr $bottleNeckXOffset - $xOffset ]
    $srcNodes($i) set Y_ [expr $bottleNeckYOffset + $yOffset ]
    $srcNodes($i) set Z_ 0.0
    $ns initial_node_pos $srcNodes($i) 10

    $ns at $stopTime "$srcNodes($i) reset"
    # random movement
    
    # $srcNodes($i) random-motion 1
    # $ns at 0.0 "$srcNodes($i) setdest [expr [rand] * $bottleNeckXOffset] [expr [rand] * $Y] [expr 1 + [rand] * 10]"
    # $ns at [ expr $stopTime ] "$srcNodes($i) setdest [expr [rand] * $bottleNeckXOffset] [expr [rand] * $Y] [expr 1 + [rand] * 10]"

}

for {set i 0} {$i < $N2} {incr i} {
    set sinkNodes($i) [$ns node]
    set angle [expr ((3.1416 - 2 * $angleOffset ) / ($N2 - 1)) * $i]
    set yOffset [expr $radius * cos($angle + $angleOffset)]
    set xOffset [expr $radius * sin($angle + $angleOffset)]
    $sinkNodes($i) set X_ [expr $bottleNeckXOffset + ($B - 1) * $bottleNeckGap  + $xOffset ]
    $sinkNodes($i) set Y_ [expr $bottleNeckYOffset + $yOffset ]
    $sinkNodes($i) set Z_ 0.0
    $ns initial_node_pos $sinkNodes($i) 10
    $ns at $stopTime "$sinkNodes($i) reset"
    
    # set sinkNodes($i) [$ns node]
    # set offset [expr ($N1 - $N2) / 2. * $yGap  ]
    # $sinkNodes($i) set X_ [expr ($B + 1) * $xGap]
    # $sinkNodes($i) set Y_ [expr $i * $yGap + $offset ]
    # $sinkNodes($i) set Z_ 0.0
    # $ns initial_node_pos $sinkNodes($i) 10

    # $sinkNodes($i) random-motion 1
    # $ns at 0.0 "$sinkNodes($i) setdest [expr rand() * $bottleNeckXOffset + $bottleNeckXOffset + ($B - 1) * $bottleNeckGap] [expr [rand] * $Y] [expr 1 + [rand] * 10]"
    # $ns at [ expr $stopTime ] "$sinkNodes($i) setdest [expr rand() * $bottleNeckXOffset + $bottleNeckXOffset + ($B - 1) * $bottleNeckGap] [expr [rand] * $Y] [expr 1 + [rand] * 10]"

}


for {set i 0} {$i < $F} {incr i} {
    # set srcNodes($i) [$ns node]
    # $srcNodes($i) set X_ 10
    # $srcNodes($i) set Y_ [expr $i * $yGap]
    # $srcNodes($i) set Z_ 0.0
    # $ns initial_node_pos $srcNodes($i) 10

    if {$useFit == "1"} {
        set srcAgents($i) [new Agent/TCP/FitW]
        $srcAgents($i) set N $N
        $srcAgents($i) set alpha $alpha
    } else {
        set srcAgents($i) [new Agent/TCP/Reno]
    }
    set traffic($i) [new Application/Traffic/Exponential]

    $traffic($i) set packetSize_ 200
    $traffic($i) set burst_time_ 100ms
	$traffic($i) set idle_time_ 0ms
	$traffic($i) set rate_ $bandwidth

    $ns attach-agent $srcNodes([round [floor [expr [rand] * $N1]]]) $srcAgents($i)
    $traffic($i) attach-agent $srcAgents($i)

    set sinkAgent($i) [new Agent/TCPSink]

    $ns attach-agent $sinkNodes([round [floor [expr [rand] * $N2]]]) $sinkAgent($i)
    $ns connect $srcAgents($i) $sinkAgent($i)
    $ns at 10 "$traffic($i) start"
    $ns at $stopTime "$traffic($i) stop"

}



# puts [$srcNodes(0) set X_]


proc stop {} {
    
    global ns traceFile namTraceFile
    $ns flush-trace
    close $traceFile
	close $namTraceFile
    exit 0
    # exec nam offline.nam
}

$ns at [expr $stopTime + 150] "stop"
$ns run



# for {set i 0} {$i < $N} {incr i} {
#     set nodes($i) [$ns node]
#     $nodes($i) random-motion 1
# }
