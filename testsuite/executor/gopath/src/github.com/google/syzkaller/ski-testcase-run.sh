#!/bin/bash
#
# Script executed after loading the testcase into the VM
#
#

## TESTING OPTIONS

error_msg(){
    echo [SKI-TESTCASE-RUN.SH] ERROR: $1
    echo [SKI-TESTCASE-RUN.SH] ERROR: Exiting!!
    exit 1
}

log_msg(){
    echo [SKI-TESTCASE-RUN.SH] $1
}


# Options mostly useful to test on the testcase in the host (i.e., disables hypercalls or other SKI functionalities)
export USC_SKI_HYPERCALLS=${USC_SKI_HYPERCALLS-0}
export USC_SKI_ENABLED=${USC_SKI_ENABLED-1}
export USC_SKI_TOTAL_CPUS=4

VM_TEST_QUIT=${VM_TEST_QUIT-1}
EMPTY_TEST_FILENAME=${EMPTY_TEST_FILENAME-./executor/empty/empty}
DEBUG_BINARY=/root/usermode/simple-app/debug


if [ $USC_SKI_ENABLED -eq 1 ]
then
	# Redirect stdin and stdout to:
	#  - write the contents on log-vm-test.txt (within the host)
	#  - send it using the hypercalls so that SKI can show it immediately to the user
	exec >  >(tee -a log-vm-test.txt | xargs -d '\n' -n 1 ${DEBUG_BINARY})
	exec 2> >(tee -a log-vm-test.txt | xargs -d '\n' -n 1 ${DEBUG_BINARY} >&2)
else
	exec >  >(tee -a log-vm-test.txt )
	exec 2> >(tee -a log-vm-test.txt >&2)
fi

# Do some checks
if ! [ -x "./bin/linux_386/ski-executor" ] ; then error_msg "Unable to find the simple binary" ; fi
if ! [ -f "$EMPTY_TEST_FILENAME" ] ; then  error_msg "$EMPTY_TEST_FILENAME not found!"; fi


# Execute the setup script (also calls FS specific scripts)
log_msg "Running setup"
chmod +x ./setup.sh
./setup.sh
log_msg "Finished setup"


log_msg "Running trinity and the empty process"
SKI_ENABLE=1
#(
	echo "Process 1 & 2 (with FORK):"
	USC_SKI_ENABLED=${SKI_ENABLE} USC_SKI_FORK_ENABLED=1 USC_SKI_CPU_AFFINITY=0 USC_SKI_TEST_NUMBER=1 USC_SKI_SOFT_EXIT_BARRIER=0 USC_SKI_USER_BARRIER=0 USC_SKI_HYPERCALLS=1 taskset --cpu-list 0 ./bin/linux_386/ski-executor &
	#PROCESS_PID=$!
    #echo "Process 1 pid is $PROCESS_PID"
    #cat /proc/$PROCESS_PID/stack
    USC_SKI_ENABLED=${SKI_ENABLE} USC_SKI_FORK_ENABLED=1 USC_SKI_CPU_AFFINITY=1 USC_SKI_TEST_NUMBER=1 USC_SKI_SOFT_EXIT_BARRIER=0 USC_SKI_USER_BARRIER=0 USC_SKI_HYPERCALLS=1 taskset --cpu-list 1 ./bin/linux_386/ski-executor &
    #PROCESS_PID=$!
	#echo "/proc/sys/kernel/randomize_va_space="
	#sysctl kernel.randomize_va_space
	#echo "Process 2 pid is $PROCESS_PID"
	#cat /proc/$PROCESS_PID/stack
	#cat /proc/$TRINITY_PID/smaps
	#RES=$?
	#if [ "$RES" -ne 0 ]
	#then
	#	/root/usermode/simple-app/debug "Error running simple testcase"
	#fi

#)&


# Call the empty process for the other two CPUs
echo "Process 3: ${EMPTY_TEST_FILENAME}"
USC_SKI_ENABLED=${SKI_ENABLE} USC_SKI_FORK_ENABLED=0 USC_SKI_CPU_AFFINITY=2 USC_SKI_TEST_NUMBER=1 USC_SKI_SOFT_EXIT_BARRIER=0 USC_SKI_USER_BARRIER=0 USC_SKI_HYPERCALLS=1 taskset --cpu-list 2 ${EMPTY_TEST_FILENAME} &
#EMPTY_PID=$!
#echo "Empty 1 pid is $EMPTY_PID"
#cat /proc/$EMPTY_PID/maps
echo "Process 4: ${EMPTY_TEST_FILENAME}"
USC_SKI_ENABLED=${SKI_ENABLE} USC_SKI_FORK_ENABLED=0 USC_SKI_CPU_AFFINITY=3 USC_SKI_TEST_NUMBER=1 USC_SKI_SOFT_EXIT_BARRIER=0 USC_SKI_USER_BARRIER=0 USC_SKI_HYPERCALLS=1 taskset --cpu-list 3 ${EMPTY_TEST_FILENAME} &
#EMPTY_PID=$!
#echo "Empty 2 pid is $EMPTY_PID"
#cat /proc/$EMPTY_PID/maps

wait


log_msg "All test processes finished!"

log_msg "Executing post-test ps command"
ps -All -f


if [ "$VM_TEST_QUIT" -eq 1 ]
then
	# Special command to signal to SKI the end of the snapshot process
	$DEBUG_BINARY "Guest finished snapshot"
fi



