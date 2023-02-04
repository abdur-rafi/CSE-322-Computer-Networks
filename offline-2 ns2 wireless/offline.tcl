namespace import ::tcl::mathfunc::*

set N [lindex $argv 0]
set F [lindex $argv 1]
set X [lindex $argv 2]
set Y $X

set stopTime 20

set ns [new Simulator]

$ns use-newtrace

set traceFile [open offline.tr w]
set namTraceFile [open offline.nam w]

$ns trace-all $traceFile
$ns namtrace-all-wireless $namTraceFile $X $Y 

set topo [new Topography]
$topo load_flatgrid $X $Y

create-god $N

set channel [new Channel/WirelessChannel]

expr { srand(19) }

# CMUPriQueue
# Queue/DropTail/PriQueue
$ns node-config -adhocRouting DSR \
    -llType LL \
    -macType Mac/802_11 \
    -ifqType CMUPriQueue \
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

    # set agents($i) [new Agent/UDP]
    # set traffic($i) [new Application/Traffic/Exponential]
    # $traffic($i) set packetSize_ 200
	# $traffic($i) set burst_time_ 100ms
	# $traffic($i) set idle_time_ 100ms
	# $traffic($i) set rate_ 1mb


    # set null [new Agent/Null]


    # set src [round [floor [expr [rand] * $N]]]
    # set dest [round [floor [expr [rand] * $N]]]

    # while {$src == $dest} {
    #     set dest [round [floor [expr [rand] * $N]]]
    # }

    # $ns attach-agent $nodes($src) $agents($i)
    # $traffic($i) attach-agent $agents($i)


    # # puts $src 
    # # puts $dest

    # $ns attach-agent $nodes($dest) $null
    # $ns connect $agents($i) $null

    $ns initial_node_pos $nodes($i) 10

}


for {set i 0} {$i < $F} {incr i} {
    set agents($i) [new Agent/UDP]
    set traffic($i) [new Application/Traffic/Exponential]
    $traffic($i) set packetSize_ 200
	$traffic($i) set burst_time_ 100ms
	$traffic($i) set idle_time_ 100ms
	$traffic($i) set rate_ 50k


    set null [new Agent/Null]


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
    $ns at [expr [rand] * $stopTime] "$traffic($i) start"   
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



$ns at [expr $stopTime + .1] "stop"

$ns run