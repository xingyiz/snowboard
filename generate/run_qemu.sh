#!/bin/sh

WORKDIR=$(pwd)
BASENAME=$(basename "$WORKDIR")
# if [ "$BASENAME" != "fuzz" ]; then
#     echo -e "${red}=== ERROR: current working directory should be 'fuzz' ===${clear}"
#     exit 1
# fi

LINUX_DIR="$WORKDIR/kernel"
IMAGE_DIR="$WORKDIR/image"

sudo qemu-system-i386 \
    -m 16G \
    -smp 6 \
    -kernel $LINUX_DIR/bzImage \
    -append "console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0" \
    -drive file=$IMAGE_DIR/bookworm.img,format=raw \
    -net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \
    -net nic,model=e1000 \
    -snapshot \
    -enable-kvm \
    -nographic \
    -pidfile vm.pid \
    2>&1 | tee vm.log
