# set ns [new Simulator]

# set traceFile [open test.tr w]
# set namTraceFile [open test.nam w]


# set n1 [$ns node]
# set n2 [$ns node]
# set db [$ns DelayBox]

# $ns duplex-link $n1 $db 10Mb 10ms Droptail
# $ns duplex-link $n2 $db 10Mb 10ms Droptail

# set srcAgent [new Agent/TCP]
# set destAgent [new Agent/TCPSink]
# set $srcAgent fid_ 1
# set $destAgent fid_ 1

# set srcTraffic [new Application/Traffic/Exponential]



# db-fulltcp.tcl 
#
# Demonstrates a simple Full-TCP file transfer with DelayBox

# setup ns
remove-all-packet-headers;            # removes all packet headers
add-packet-header IP TCP;             # adds TCP/IP headers
set ns [new Simulator];               # instantiate the simulator

set traceFile [open test.tr w]
set namTraceFile [open test.nam w]

$ns trace-all $traceFile
$ns namtrace-all $namTraceFile 


# create nodes
set n_src [$ns node]
set db(0) [$ns DelayBox]
set db(1) [$ns DelayBox]
set n_sink [$ns node]

# setup links
$ns duplex-link $db(0) $db(1) 100Mb 1ms DropTail
$ns duplex-link $n_src $db(0) 100Mb 1ms DropTail
$ns duplex-link $n_sink $db(1) 100Mb 1ms DropTail



set src [new Agent/TCP]
set traffic [new Application/Traffic/Exponential]
$traffic attach-agent $src
set sink [new Agent/TCPSink]
$src set fid_ 1
$sink set fid_ 1

# attach agents to nodes
$ns attach-agent $n_src $src
$ns attach-agent $n_sink $sink

# make the connection
$ns connect $src $sink

# create random variables
set recvr_delay [new RandomVariable/Uniform];     # delay 1-20 ms
$recvr_delay set min_ 1 
$recvr_delay set max_ 20
set sender_delay [new RandomVariable/Uniform];    # delay 20-100 ms
$sender_delay set min_ 20
$sender_delay set max_ 100
set recvr_bw [new RandomVariable/Constant];       # bw 100 Mbps
$recvr_bw set val_ 100
set sender_bw [new RandomVariable/Uniform];       # bw 1-20 Mbps
$sender_bw set min_ 1
$sender_bw set max_ 20
set loss_rate [new RandomVariable/Uniform];       # loss 0-1% loss
$loss_rate set min_ 0
$loss_rate set max_ 0.01

# setup rules for DelayBoxes 
$db(0) add-rule [$n_src id] [$n_sink id] $recvr_delay $loss_rate $recvr_bw
$db(1) add-rule [$n_src id] [$n_sink id] $sender_delay $loss_rate $sender_bw


$db(0) set-delay-file "db-fulltcp-db00.out"
$db(1) set-delay-file "db-fulltcp-db01.out"

proc stop {} {
    global ns traceFile namTraceFile db
    $ns flush-trace
    close $traceFile
	close $namTraceFile
    $db(0) close-delay-file
    $db(1) close-delay-file
    exit 0
    # exec nam offline.nam
}
$ns at 0.5 "$traffic start"

$ns at [expr 1000 ] "stop"
$ns run
