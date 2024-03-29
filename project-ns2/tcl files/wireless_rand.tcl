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

set stopTime 40
set delay 0
set startTime 10
# set radius 100
# set bottleNeckXOffset 200
# set bottleNeckYOffset 200
# set bottleNeckGap 150

# set Y [expr 2 * $radius + 10]
set Y $X

set N [expr $N1 + $N2]

set ns [new Simulator]

$ns use-newtrace

set traceFile [open $traceFile w]
set namTraceFile [open $namTraceFile w]

$ns trace-all $traceFile
$ns namtrace-all-wireless $namTraceFile $X $Y 

set topo [new Topography]
$topo load_flatgrid $X $Y

create-god [expr $N1 + $N2 + $B]

set channel [new Channel/WirelessChannel]
# expr { srand(19) }
# LL set delay_ 100ms
# 84245.901732 5.228097 0.830036 0.134892 0.891963
$ns node-config -adhocRouting DSDV \
    -llType LL \
    -macType Mac/802_11 \
    -ifqType Queue/DropTail \
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
    -movementTrace OFF \		

proc UniformErr {} {
    global dropRate
    set err [new ErrorModel/Uniform $dropRate pkt]
    return $err
}
# 590078.809479 2.040056 0.952591 0.025485 0.079505

$ns node-config -IncomingErrProc UniformErr -OutgoingErrProc UniformErr  \


# set angleOffset .3

# for {set i 0} {$i < $N1} {incr i} {
#     set srcNodes($i) [$ns node]
#     # set angle [expr ((3.1416 - 2 * $angleOffset ) / ($N1 - 1)) * $i]
#     # set yOffset [expr $radius * cos($angle + $angleOffset )]
#     # set xOffset [expr $radius * sin($angle + $angleOffset )]
#     $srcNodes($i) set X_ [expr [rand] * $X ]
#     $srcNodes($i) set Y_ [expr [rand] * $Y ]
#     $srcNodes($i) set Z_ 0.0
#     $ns initial_node_pos $srcNodes($i) 10

#     $ns at [expr $stopTime + $delay] "$srcNodes($i) reset"
#     # random movement
    
#     $srcNodes($i) random-motion 1
#     $ns at 0.0 "$srcNodes($i) setdest [expr [rand] * $X] [expr [rand] * $Y] [expr 1 + [rand] * $speed]"
#     for {set j 0} {$j < 10} {incr j} {
#         $ns at [ expr $stopTime / (10 - $j) ] "$srcNodes($i) setdest [expr [rand] * $X] [expr [rand] * $Y] [expr 1 + [rand] * $speed]"        
#     }

# }

# for {set i 0} {$i < $N2} {incr i} {
#     set sinkNodes($i) [$ns node]
#     # set angle [expr ((3.1416 - 2 * $angleOffset ) / ($N2 - 1)) * $i]
#     # set yOffset [expr $radius * cos($angle + $angleOffset)]
#     # set xOffset [expr $radius * sin($angle + $angleOffset)]
#     $sinkNodes($i) set X_ [expr [rand] * $X ]
#     $sinkNodes($i) set Y_ [expr [rand] * $X ]
#     $sinkNodes($i) set Z_ 0.0
#     $ns initial_node_pos $sinkNodes($i) 10
#     $ns at [expr $stopTime + $delay] "$sinkNodes($i) reset"
    
#     # set sinkNodes($i) [$ns node]
#     # set offset [expr ($N1 - $N2) / 2. * $yGap  ]
#     # $sinkNodes($i) set X_ [expr ($B + 1) * $xGap]
#     # $sinkNodes($i) set Y_ [expr $i * $yGap + $offset ]
#     # $sinkNodes($i) set Z_ 0.0
#     # $ns initial_node_pos $sinkNodes($i) 10

#     $sinkNodes($i) random-motion 1
#     $ns at 0.0 "$sinkNodes($i) setdest [expr rand() * $X] [expr [rand] * $Y] [expr 1 + [rand] * $speed]"
#     for {set j 0} {$j < 10} {incr j} {
#         $ns at [ expr $stopTime /  (10-$j) ] "$sinkNodes($i) setdest [expr rand() * $X] [expr [rand] * $Y] [expr 1 + [rand] * $speed]"        
#     }

# }
# # LL set delay_ 200ms
# # $ns node-config -IncomingErrProc UniformErr  \

# # for {set i 0} {$i < $B} {incr i} {
# #     set bottleNeckNodes($i) [$ns node]
# #     $bottleNeckNodes($i) set X_ [expr $bottleNeckXOffset + $i * $bottleNeckGap]
# #     $bottleNeckNodes($i) set Y_ [expr $bottleNeckYOffset  ]
# #     $bottleNeckNodes($i) set Z_ 0.0
# #     $ns initial_node_pos $bottleNeckNodes($i) 10
# #     $ns at [expr $stopTime + $delay] "$bottleNeckNodes($i) reset"

# # }


# for {set i 0} {$i < $F} {incr i} {
#     # set srcNodes($i) [$ns node]
#     # $srcNodes($i) set X_ 10
#     # $srcNodes($i) set Y_ [expr $i * $yGap]
#     # $srcNodes($i) set Z_ 0.0
#     # $ns initial_node_pos $srcNodes($i) 10

#     if {$useFit == "1"} {
#         set srcAgents($i) [new Agent/TCP/FitW]
#         $srcAgents($i) set N $N
#         $srcAgents($i) set alpha $alpha
#     } else {
#         set srcAgents($i) [new Agent/TCP]
#     }
#     set traffic($i) [new Application/Traffic/Exponential]

#     $traffic($i) set packetSize_ 200
#     $traffic($i) set burst_time_ 1s
# 	$traffic($i) set idle_time_ 10ms
# 	$traffic($i) set rate_ $bandwidth

#     $ns attach-agent $srcNodes([round [floor [expr [rand] * $N1]]]) $srcAgents($i)
#     $traffic($i) attach-agent $srcAgents($i)

#     set sinkAgent($i) [new Agent/TCPSink]

#     $ns attach-agent $sinkNodes([round [floor [expr [rand] * $N2]]]) $sinkAgent($i)
#     $ns connect $srcAgents($i) $sinkAgent($i)
#     $ns at $startTime "$traffic($i) start"
#     $ns at [expr $stopTime] "$traffic($i) stop"

# }


for {set i 0} {$i < $N} {incr i} {
    set nodes($i) [$ns node]
    $nodes($i) set X_ [expr [rand] * $X ]
    $nodes($i) set Y_ [expr [rand] * $X ]
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
    $ns at [expr $stopTime] "$traffic($i) stop"

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

$ns at [expr $stopTime + 1] "stop"
$ns run



# for {set i 0} {$i < $N} {incr i} {
#     set nodes($i) [$ns node]
#     $nodes($i) random-motion 1
# }
