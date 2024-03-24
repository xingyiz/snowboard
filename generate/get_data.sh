#!/bin/bash

for prog_num in {1..114}; do
    prog_file="programs/$prog_num.syz"
    echo "Processing $prog_file"
    ./syz-execprog -repeat=1 -procs=1 -save=$prog_num.data $prog_file
done

scp -o StrictHostKeyChecking=no *.data xingyi@10.0.2.10:/home/xingyi/snowboard/generate/input/data/
