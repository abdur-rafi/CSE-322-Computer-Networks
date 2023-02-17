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
set speed [lindex $argv 12]


set radius 100
set Y [expr 2 * $radius + 10]

global opt
set opt(chan)       Channel/WirelessChannel
set opt(prop)       Propagation/TwoRayGround
set opt(netif)      Phy/WirelessPhy
set opt(mac)        Mac/802_11
set opt(ifq)        Queue/DropTail
set opt(ll)         LL
set opt(ant)        Antenna/OmniAntenna
set opt(ifqlen)         50
set opt(nWired)         1
set opt(adhocRouting)   DSDV
set opt(cp)             ""
# set opt(sc)             "../mobility/scene/scen-3-test"

set startTime 10
set delay 0
set stopTime 40


set ns   [new Simulator]
$ns use-newtrace
# expr { srand(19) }

# set up for hierarchical routing
$ns node-config -addressType hierarchical
# AddrParams set domain_num_ 3
# # wired wireless wireless
# lappend cluster_num 2 1 1  
# AddrParams set cluster_num_ $cluster_num
# lappend eilastlevel [ expr $N1 ] [ expr $N2 ] 2 2
# AddrParams set nodes_num_ $eilastlevel

AddrParams set domain_num_ 1
# wired wireless wireless
lappend cluster_num 2 
AddrParams set cluster_num_ $cluster_num
lappend eilastlevel [ expr $N1 + 1 ] [ expr $N2 + 1 ]
AddrParams set nodes_num_ $eilastlevel

set traceFile  [open $traceFile w]
$ns trace-all $traceFile
set namTraceFile [open $namTraceFile w]
$ns namtrace-all-wireless $namTraceFile $X $Y


set topo   [new Topography]
$topo load_flatgrid $X $Y
create-god [ expr 4 ]





# create addresses

set waddr1 {0.0.0 }
for {set i 1} {$i - 1 < $N1} {incr i} {
  lappend waddr1 0.0.$i
}
set waddr2 {0.1.0 }
for {set i 1} {$i - 1 < $N2} {incr i} {
  lappend waddr2 0.1.$i
}

# puts "$waddr"
# set addr1 {1.0.0 1.0.1}
# # for {set i 1} {$i - 1 < $N1} {incr i} {
# #   lappend addr1 0.0.$i
# # }
# set addr2 {2.0.0 2.0.1}
# for {set i 1} {$i - 1 < $N2} {incr i} {
#   lappend addr2 1.0.$i
# }

for {set i 0} {$i < $N1} {incr i} {
  set srcNodes($i) [$ns node [ lindex $waddr1 [ expr $i + 1] ]]
  # $srcNodes($i) set X_ [expr 10]
  # $srcNodes($i) set Y_ [expr 10 + $i * 10]
  # $srcNodes($i) set Z_ [expr 0]

  # $ns initial_node_pos $srcNodes($i) 10
  $ns at $stopTime "$srcNodes($i) reset"
}

for {set i 0} {$i < $N2} {incr i} {
  set sinkNodes($i) [$ns node [ lindex $waddr2 [ expr $i + 1] ]]
  # $ns initial_node_pos $sinkNodes($i) 10
  # $sinkNodes($i) set X_ [expr 200]
  # $sinkNodes($i) set Y_ [expr 10 + $i * 10]
  # $sinkNodes($i) set Z_ [expr 0]
  $ns at $stopTime "$sinkNodes($i) reset"
}

$ns node-config -adhocRouting $opt(adhocRouting) \
  -llType $opt(ll) \
  -macType $opt(mac) \
  -ifqType $opt(ifq) \
  -ifqLen $opt(ifqlen) \
  -energyModel "EnergyModel" \
  -initialEnergy 50.0 \
  -txPower .4 \
  -rxPower .3 \
  -idlePower 0.1 \
  -sleepPower .01 \
  -antType $opt(ant) \
  -propInstance [new $opt(prop)] \
  -phyType $opt(netif) \
  -channel [new $opt(chan)] \
  -topoInstance $topo \
  -wiredRouting ON \
  -agentTrace ON \
  -routerTrace ON \
  -macTrace OFF \
  -movementTrace OFF \

#  set up base stations

set BS(0) [$ns node [lindex $waddr1 0]]
set BS(1) [$ns node [lindex $waddr2 0]]
$BS(0) random-motion 0
$BS(1) random-motion 0

$BS(0) set X_ 250
$BS(0) set Y_ [expr $Y / 2]
$BS(0) set Z_ 0.0


$BS(1) set X_ [expr 400]
$BS(1) set Y_ [expr $Y / 2]
$BS(1) set Z_ 0.0

for {set i 0} {$i < $N1} {incr i} {
  $ns duplex-link $srcNodes($i) $BS(0) 100mb 200ms DropTail
}

for {set i 0} {$i < $N2} {incr i} {
  $ns duplex-link $sinkNodes($i) $BS(1)  100mb 200ms DropTail
}

$ns node-config -wiredRouting OFF

# set i 0
# set nodes($i) [$ns node [lindex $addr1 [expr $i]]]
# $nodes($i) set X_ 350
# $nodes($i) set Y_ [expr $Y / 2]
# $nodes($i) set Z_ 0
# $ns initial_node_pos $nodes($i) 10
# $nodes($i) base-station [AddrParams addr2id [ $BS(0) node-addr ]]

# set i 1
# set nodes($i) [$ns node [lindex $addr2 [expr $i]]]
# $nodes($i) set X_ 300
# $nodes($i) set Y_ [expr $Y / 2]
# $nodes($i) set Z_ 0
# $ns initial_node_pos $nodes($i) 10
# $nodes($i) base-station [AddrParams addr2id [ $BS(1) node-addr ]]


# for {set i 0} {$i < 2} {incr i} {
#   set nodes($i) [$ns node [lindex $waddr [expr $i ] ]]
#   $nodes($i) set X_ 300
#   $nodes($i) set Y_ [expr $Y / 2]
#   $nodes($i) set Z_ 0
#   puts()
#   $nodes($i) base-station [AddrParams addr2id [$BS([expr $i % 2]) node-addr]]
  
# }

# for {set i 0} {$i < $N1} {incr i} {
# $srcNodes($i) base-station [AddrParams addr2id [ $BS(1) node-addr ]]
  
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

$ns at [expr $stopTime + .01] "stop"
$ns run
