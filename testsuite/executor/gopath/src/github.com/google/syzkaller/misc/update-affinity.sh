#!/bin/bash


UPDATE_PROCESS_LIST="["
# starts in 0,...,cpu-1
UPDATE_NEW_CPU=2
#UPDATE_NEW_CPU=0

while read LINE
do
    PID=$(echo $LINE | cut -d " " -f 4)
    PRIO=$(taskset -p $PID)
    echo $PRIO $PID $LINE
	for x in $UPDATE_PROCESS_LIST
	do
		#echo ""
		if [[ $LINE == *"$x"* ]]
		then
			echo "Found $x in $LINE"
		#	echo ""
			RES=$(taskset -c -p $UPDATE_NEW_CPU $PID 2>&1)
			if [[ $RES == *Invalid* ]]
			then
				echo "fail to set CPU affinity for PID $PID" 
				break
			fi
			PRIO=$(taskset -p $PID)
			echo "Updated:" $PRIO $PID $LINE
			break
		fi
	done
done < <(ps -All -f )

