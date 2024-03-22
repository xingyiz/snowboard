#!/bin/bash

# Uncomment when debugging the testcase script
#set -x
#set -v


# Update the affinity of the internal kernel threads
chmod +x ./misc/update-affinity.sh
./misc/update-affinity.sh

# Set "max locked memory" to unlimited
ulimit -l unlimited
ulimit


echo "** lsmod:"
lsmod

echo "** /proc/modules:"
cat /proc/modules


