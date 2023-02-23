namespace import ::tcl::mathfunc::*

set N1 [lindex $argv 0]
set N2 [lindex $argv 1]
set B [lindex $argv 2]
set F [lindex $argv 3]
set X [lindex $argv 4]
set useFit [lindex $argv 5]
set N [lindex $argv 6]
set alpha [lindex $argv 7]
set packetRate [lindex $argv 8]
set dropRate [lindex $argv 9]
set traceFile [lindex $argv 10]
set namTraceFile [lindex $argv 11]
# set N 3
# set F 1
# set X 1000
# puts $packetRate
# puts "$N1 ,$N2, $F, $N, $alpha, $packetRate, $dropRate"
set Y $X
set delta 0
set stopTime 40
set startTime 10
# global defaultRNG
# $defaultRNG seed 999

set ns [new Simulator]

$ns use-newtrace

# $ns use-newtrace

set traceFile [open $traceFile w]
set namTraceFile [open $namTraceFile w]

$ns trace-all $traceFile
$ns namtrace-all $namTraceFile 

# expr { srand(19) }
for {set i 0} {$i < $B} {incr i} {
    set bottleNeckNodes($i) [$ns DelayBox]
    $ns at  [expr $stopTime + $delta] "$bottleNeckNodes($i) reset"
}
for {set i 1} {$i < $B} {incr i} {
    # set recvr_delay [new RandomVariable/Uniform];
    # $recvr_delay1 set min_ 500ms
    # $recvr_delay1 set max_ 1500ms
    # set loss_module($i) [new ErrorModel/Uniform $dropRate pkt ]
    $ns duplex-link $bottleNeckNodes([expr $i - 1]) $bottleNeckNodes($i) 5Gb 1ms DropTail
    # $ns link-lossmodel $loss_module($i) $bottleNeckNodes([expr $i - 1]) $bottleNeckNodes($i) 
}


for {set i 0} {$i < $N1} {incr i} {
    set srcNodes($i) [$ns node]
    $ns duplex-link $srcNodes($i) $bottleNeckNodes(0) 2Gb 10ms DropTail 
    $ns at  [expr $stopTime + $delta] "$srcNodes($i) reset"

}
for {set i 0} {$i < $N2} {incr i} {
    set sinkNodes($i) [$ns node]
    $ns duplex-link $sinkNodes($i) $bottleNeckNodes(1) 2Gb 10ms DropTail
    $ns at  [expr $stopTime + $delta] "$sinkNodes($i) reset"

}



for {set i 0} {$i < $F} {incr i} {
    if {$useFit == "1"} {
        set srcAgents($i) [new Agent/TCP/FitW]
        $srcAgents($i) set N $N
        $srcAgents($i) set alpha $alpha
    } else {
        set srcAgents($i) [new Agent/TCP]
    }
    $srcAgents($i) set fid_ [expr $i + 1]
    set traffic($i) [new Application/Traffic/Exponential]
    $traffic($i) set packetSize_ 200
    $traffic($i) set burst_time_ 1s
	$traffic($i) set idle_time_ 10ms
	# $traffic($i) set rate_ [expr $packetRate * 200]
	$traffic($i) set rate_ $packetRate 
    set srcId [round [floor [expr [rand] * $N1]]]
    $ns attach-agent $srcNodes($srcId) $srcAgents($i)
    $traffic($i) attach-agent $srcAgents($i)

    set sinkAgent($i) [new Agent/TCPSink]
    $sinkAgent($i) set fid_ [expr $i + 1]
    set snkId [round [floor [expr [rand] * $N2]]]
    $ns attach-agent $sinkNodes($snkId) $sinkAgent($i)

    $ns connect $srcAgents($i) $sinkAgent($i)

    set recvr_delay [new RandomVariable/Uniform];
    $recvr_delay set min_ 500
    $recvr_delay set max_ 750
    set sender_delay [new RandomVariable/Uniform];
    $sender_delay set min_ 500
    $sender_delay set max_ 750
    set recvr_bw [new RandomVariable/Constant];
    $recvr_bw set val_ 1kb
    set sender_bw [new RandomVariable/Constant];
    $sender_bw set val_ 5Gb
    set loss_rate [new RandomVariable/Constant];
    $loss_rate set val_ 0.5
    $bottleNeckNodes(0) add-rule [$srcNodes($srcId) id] [$sinkNodes($snkId) id] $recvr_delay $loss_rate $recvr_bw
            # $bottleNeckNodes($i) add-rule [$srcNodes($j) id] [$sinkNodes($k) id] $sendr $loss_rate $recvr_bw


    $ns at $startTime "$traffic($i) start"
    $ns at $stopTime "$traffic($i) stop"

}

# for {set i 0} {$i < $B} {incr i} {
#     set recvr_delay [new RandomVariable/Uniform];
#     $recvr_delay set min_ 500
#     $recvr_delay set max_ 750
#     set sender_delay [new RandomVariable/Uniform];
#     $sender_delay set min_ 500
#     $sender_delay set max_ 750
#     set recvr_bw [new RandomVariable/Constant];
#     $recvr_bw set val_ 1kb
#     set sender_bw [new RandomVariable/Constant];
#     $sender_bw set val_ 5Gb
#     set loss_rate [new RandomVariable/Constant];
#     $loss_rate set val_ 0.5
#     for {set j 0} {$j < $N1} {incr j} {
#         for {set k 0} {$k < $N2} {incr k} {
#             $bottleNeckNodes($i) add-rule [$srcNodes($j) id] [$sinkNodes($k) id] $recvr_delay $loss_rate $recvr_bw
#             # $bottleNeckNodes($i) add-rule [$srcNodes($j) id] [$sinkNodes($k) id] $sendr $loss_rate $recvr_bw

#         }
#     }
# }

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

