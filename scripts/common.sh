#!/bin/bash

CURR_DIR=$(pwd)
export MAIN_HOME=$(dirname $CURR_DIR)
echo $MAIN_HOME

# test prerequisite
export BASEIMAGE=$MAIN_HOME/testsuite/image/base-vm.img
export SNAPSHOT=$MAIN_HOME/testsuite/image/snapshot.img
export KERNEL_DIR=$MAIN_HOME/testsuite/kernel/linux-5.12-rc3
export SEQUENTIAL_CORPUS=$MAIN_HOME/generate/my_input/data
