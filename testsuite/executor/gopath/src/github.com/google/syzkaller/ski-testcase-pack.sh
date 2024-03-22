#!/bin/bash


# Script executed on the host before packing and sending the testcase to the VM
# Should return 0 if sucessfull, otherwise the run-create-snapshot.sh aborts
pushd executor/empty
make
MAKE_RESULT=$?
if [ $MAKE_RESULT -ne 0 ] ; then exit $MAKE_RESULT; fi
popd

export GOPATH=`pwd`/../../../../../gopath
export GOROOT=`pwd`/../../../../../goroot
export PATH=$GOPATH/bin:$PATH
export PATH=$GOROOT/bin:$PATH

make TARGETVMARCH=386 TARGETARCH=386
MAKE_RESULT=$?


exit $MAKE_RESULT

