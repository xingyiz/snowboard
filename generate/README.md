# Generating New Testcases for Snowboard

This directory contains the scripts and data used to generate new testcases for Snowboard.

1. Place the `bzImage` into the kernel directory. 
2. Build the image
```
mkdir image && cd image

cp ../create-image.sh .

./create-image.sh --feature full -a i386

cd ..
```

3. Add your programs in a `programs` dir
4. Run `./bake.sh` to add the necessary scripts into the image
5. Run `./run_qemu.sh`.
6. In the VM, 
```
cd performance
./get_data.sh
```
7. If you need to modify syzkaller
```
make TARGETOS=linux TARGETARCH=386 -j`nproc`
```
