#!/bin/bash

# set -e

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
clear='\033[0m'

WORKDIR=$(pwd)
BASENAME=$(basename "$WORKDIR")
if [ "$BASENAME" != "generate" ]; then
    echo -e "${red}=== ERROR: current working directory should be 'generate' ===${clear}"
    exit 1
fi

FOLDER_NAME="performance"
MAIN_DIR=$(realpath .)
SNOWBOARD_DIR=$(realpath ..)
IMAGE_DIR="$MAIN_DIR/image"
ADD_DIR="$IMAGE_DIR/$FOLDER_NAME"
PROGRAM_DIR="$MAIN_DIR/programs"
SYZKALLER_DIR="$SNOWBOARD_DIR/testsuite/executor/gopath/src/github.com/google/syzkaller"
SYZKALLER_BIN_DIR="$SYZKALLER_DIR/bin/linux_386"
SCHEDEXT_TOOLS_DIR="$MAIN_DIR/externals/sched_ext/tools/sched_ext/build/bin"
SSH_DIR="$HOME/.ssh"

if [ ! -d "$ADD_DIR" ]; then
    mkdir -p $ADD_DIR
fi


# Variables affected by options
ARCH=$(uname -m)
RELEASE=bookworm
FEATURE=minimal
SEEK=2047
PERF=false
DIR=chroot

pushd $ADD_DIR
rm -rf *
popd

cp -r $PROGRAM_DIR/ $ADD_DIR/
cp ./get_data.sh $ADD_DIR/
cp $SYZKALLER_BIN_DIR/syz-execprog $ADD_DIR/
cp $SYZKALLER_BIN_DIR/syz-executor $ADD_DIR/

scp -P 10021 -i $IMAGE_DIR/bookworm.id_rsa $IMAGE_DIR/$FOLDER_NAME/get_data.sh root@localhost:/root/$FOLDER_NAME/get_data.sh

pushd $IMAGE_DIR
sudo rm -f $RELEASE.img
dd if=/dev/zero of=$RELEASE.img bs=1M seek=$SEEK count=1
sudo mkfs.ext4 -F $RELEASE.img
sudo mkdir -p /mnt/$DIR
sudo mount -o loop $RELEASE.img /mnt/$DIR
sudo rm -rf $DIR/root/*
sudo cp -r ./$FOLDER_NAME $DIR/root/
sudo cp $SSH_DIR/id_ed25519 $DIR/root/.ssh/
sudo cp -a $DIR/. /mnt/$DIR/.
sudo umount /mnt/$DIR
popd
