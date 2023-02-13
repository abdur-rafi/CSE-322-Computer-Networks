### This simulation is an example of combination of wired and wireless
### topologies.
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

set Y $X
global opt
set opt(chan)       Channel/WirelessChannel
set opt(prop)       Propagation/TwoRayGround
set opt(netif)      Phy/WirelessPhy
set opt(mac)        Mac/802_11
set opt(ifq)        Queue/DropTail/PriQueue
set opt(ll)         LL
set opt(ant)        Antenna/OmniAntenna
set opt(ifqlen)         50
set opt(nWired)         1
set opt(adhocRouting)   DSDV
set opt(cp)             ""
set opt(sc)             "../mobility/scene/scen-3-test"

set startTime 10
set delay 0
set stopTime 40


set ns   [new Simulator]
$ns use-newtrace
expr { srand(19) }

# set up for hierarchical routing
$ns node-config -addressType hierarchical
AddrParams set domain_num_ 3
lappend cluster_num 1 1 1
AddrParams set cluster_num_ $cluster_num
lappend eilastlevel [expr $opt(nWired)] [expr $N1 + 1] [expr $N2 + 1]
AddrParams set nodes_num_ $eilastlevel

set traceFile  [open $traceFile w]
$ns trace-all $traceFile
set namTraceFile [open $namTraceFile w]
$ns namtrace-all $namTraceFile


set topo   [new Topography]
$topo load_flatgrid $X $Y
create-god [expr $N1 + $N2 + 2]

# create addresses

set waddr {0.0.0}
for {set i 0} {$i < $opt(nWired)} {incr i} {
  lappend $waddr 0.0.$i
}
set addr1 {1.0.0}
for {set i 1} {$i - 1 < $N1} {incr i} {
  lappend addr1 1.0.$i
}
set addr2 {2.0.0}
for {set i 1} {$i - 1 < $N2} {incr i} {
  lappend addr2 2.0.$i
}
# wired node
for {set i 0} {$i < $opt(nWired)} {incr i} {
  set W($i) [$ns node [lindex $waddr $i]]
}
$ns node-config -adhocRouting $opt(adhocRouting) \
  -llType $opt(ll) \
  -macType $opt(mac) \
  -ifqType $opt(ifq) \
  -ifqLen $opt(ifqlen) \
  -antType $opt(ant) \
  -propInstance [new $opt(prop)] \
  -phyType $opt(netif) \
  -channel [new $opt(chan)] \
  -topoInstance $topo \
  -wiredRouting ON \
  -agentTrace ON \
  -routerTrace OFF \
  -macTrace OFF

#  set up base stations

set BS(0) [$ns node [lindex $addr1 0]]
set BS(1) [$ns node [lindex $addr2 0]]
$BS(0) random-motion 0
$BS(1) random-motion 0

$BS(0) set X_ 350
$BS(0) set Y_ [expr $Y / 2]
$BS(0) set Z_ 0.0


$BS(1) set X_ [expr $X - 10]
$BS(1) set Y_ [expr $Y / 2]
$BS(1) set Z_ 0.0

$ns duplex-link $W(0) $BS(0) 2Gb 500ms DropTail
$ns duplex-link $W(0) $BS(1) 2Gb 500ms DropTail
$ns duplex-link-op $W(0) $BS(0) orient left
$ns duplex-link-op $W(0) $BS(1) orient right

set loss_module0 [new ErrorModel/Uniform $dropRate pkt ]
set loss_module1 [new ErrorModel/Uniform $dropRate pkt ]

$ns link-lossmodel $loss_module0 $W(0) $BS(0)
$ns link-lossmodel $loss_module1 $W(0) $BS(1) 


set radius 100
set bottleNeckXOffset [$BS(0) set X_]
set bottleNeckYOffset [$BS(0) set Y_]
set bottleNeckGap [$BS(1) set X_]
set bottleNeckGap [expr $bottleNeckGap - $bottleNeckXOffset]
set angleOffset .3

#configure for mobilenodes
$ns node-config -wiredRouting OFF

for {set i 0} {$i < $N1} {incr i} {
  set srcNodes($i) [$ns node [lindex $addr1 [expr $i+1]]]
  set angle [expr ((3.1416 - 2 * $angleOffset ) / ($N1 - 1)) * $i]
  set yOffset [expr $radius * cos($angle + $angleOffset )]
  set xOffset [expr $radius * sin($angle + $angleOffset )]
  $srcNodes($i) set X_ [expr $bottleNeckXOffset - $xOffset ]
  $srcNodes($i) set Y_ [expr $bottleNeckYOffset + $yOffset ]
  $srcNodes($i) set Z_ 0.0
  $ns initial_node_pos $srcNodes($i) 10
  $srcNodes($i) base-station [AddrParams addr2id [$BS(0) node-addr]]

  $ns at $stopTime "$srcNodes($i) reset"
  # random movement

  # $srcNodes($i) random-motion 1
  # $ns at 0.0 "$srcNodes($i) setdest [expr [rand] * $bottleNeckXOffset] [expr [rand] * $Y] [expr 1 + [rand] * 10]"
  # $ns at [ expr $stopTime ] "$srcNodes($i) setdest [expr [rand] * $bottleNeckXOffset] [expr [rand] * $Y] [expr 1 + [rand] * 10]"

}

# for {set j 0} {$j < $opt(n1)} {incr j} {
#   set src($j) [ $ns node [lindex $addr1 \
#           [expr $j+1]] ]
#   $src($j) base-station [AddrParams addr2id [$BS(0) node-addr]]
#   # $src($j) set X_ [expr rand() * $opt(x)]
#   # $src($j) set Y_ [expr rand() * $opt(y)]
#   $src($j) set X_ 1
#   $src($j) set Y_ 1
#   $src($j) set Z_ 0
# }


for {set i 0} {$i < $N2} {incr i} {
  set sinkNodes($i) [$ns node [lindex $addr2 [expr $i+1]]]
  set angle [expr ((3.1416 - 2 * $angleOffset ) / ($N2 - 1)) * $i]
  set yOffset [expr $radius * cos($angle + $angleOffset)]
  set xOffset [expr $radius * sin($angle + $angleOffset)]
  $sinkNodes($i) set X_ [expr $bottleNeckXOffset + ($B - 1) * $bottleNeckGap  + $xOffset ]
  $sinkNodes($i) set Y_ [expr $bottleNeckYOffset + $yOffset ]
  $sinkNodes($i) set Z_ 0.0
  $sinkNodes($i) base-station [AddrParams addr2id [$BS(1) node-addr]]

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
#  for {set j 0} {$j < $opt(n2)} {incr j} {
#   set dest($j) [ $ns node [lindex $addr2 \
#           [expr $j+1]] ]
#   $dest($j) base-station [AddrParams addr2id [$BS(1) node-addr]]
#   # $dest($j) set X_ [expr rand() * $opt(x)]
#   # $dest($j) set Y_ [expr rand() * $opt(y)]
#   $dest($j) set X_ [expr $opt(x) - 1]
#   $dest($j) set Y_ [expr $opt(y) - 1]
#   $dest($j) set Z_ 0
# }


for {set i 0} {$i < $F} {incr i} {

  if {$useFit == "1"} {
    set srcAgents($i) [new Agent/TCP/FitW]
    $srcAgents($i) set N $N
    $srcAgents($i) set alpha $alpha
  } else {
    set srcAgents($i) [new Agent/TCP]
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

$ns at [expr $stopTime + 150] "stop"
$ns run
# setup TCP connections
# set tcp1 [new Agent/TCP]
# #   $tcp1 set class_ 2
# set sink1 [new Agent/TCPSink]
# $ns attach-agent $src(0) $tcp1
# $ns attach-agent $dest(0) $sink1
# $ns connect $tcp1 $sink1
# set exp1 [new Application/Traffic/Exponential]
# $exp1 attach-agent $tcp1
# $ns at .01 "$exp1 start"
# $ns at $opt(stop) "$exp1 stop"

#   set tcp2 [new Agent/TCP]
#   $tcp2 set class_ 2
#   set sink2 [new Agent/TCPSink]
#   $ns attach-agent $src(1) $tcp2
#   $ns attach-agent $dest(2) $sink2
#   $ns connect $tcp2 $sink2
#   set ftp2 [new Application/FTP]
#   $ftp2 attach-agent $tcp2
#   $ns at 180 "$ftp2 start"


# for {set i } {$i < $opt(n1) } {incr i} {
#   $ns at $opt(stop).0000010 "$src($i) reset";
# }
# for {set i } {$i < $opt(n2) } {incr i} {
#   $ns at $opt(stop).0000010 "$dest($i) reset";
# }
# $ns at $opt(stop).0000010 "$BS(0) reset";
# $ns at $opt(stop).0000010 "$BS(1) reset";


# $ns at $opt(stop).1 "puts \"NS EXITING...\" ; $ns halt"

#   puts "Starting Simulation..."




# proc stop {} {
#     global ns opt
#     $ns flush-trace
#     close $opt(tr)
# 	close $opt(namtr)
#     exit 0
#     # exec nam offline.nam
# }

# $ns at [expr $opt(stop) + 20] "stop"
# $ns run
