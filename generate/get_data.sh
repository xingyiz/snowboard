#!/bin/bash

for prog_num in {100..200}; do
    prog_file="new_programs/$prog_num"
    echo "Processing $prog_file"
    ./syz-execprog -repeat=1 -procs=1 -save=$prog_num.data $prog_file
done

scp -o StrictHostKeyChecking=no *.data xingyi@10.0.2.10:/home/xingyi/snowboard/generate/new_input/data/
