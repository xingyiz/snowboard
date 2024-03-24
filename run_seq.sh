#!/bin/bash

SNOWBOARD_DIR=$HOME/snowboard
STORAGE_DIR=$SNOWBOARD_DIR/storage
VMM_DIR=$SNOWBOARD_DIR/vmm
SCRIPTS_DIR=$SNOWBOARD_DIR/scripts
SYZKALLER_DIR=$SNOWBOARD_DIR/testsuite/executor/gopath/src/github.com/google/syzkaller

# Clear vmm
# rm -rf $VMM_DIR/install/bin

# pushd $SYZKALLER_DIR
# ./ski-testcase-pack.sh
# popd

# Run set up script
pushd $SCRIPTS_DIR
source setup.sh $SNOWBOARD_DIR/storage
pushd test
for i in {1..114..10}
do
    start_num=$i
    end_num=$((i+9))
    if [ $end_num -gt 114 ]
    then
        end_num=114
    fi
    echo "Processing programs: $start_num to $end_num"

    # Run sequential analysis
    # clear
    # ./run-all.sh $start_num $end_num

    # cd $STORAGE_DIR
    # mv sequential-analysis-2024* sequential-analysis-$start_num-$end_num
    # cd $SCRIPTS_DIR/test

    # Generate concurrent tests
    echo "5" | python3 generator.py $STORAGE_DIR/sequential-analysis-$start_num-$end_num
done
popd
popd
