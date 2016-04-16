#!/bin/bash -e
. ../lfs.comm

configure() {
    # verify user ID
    if [ $UID != 0 ]; then
        echo "need root user to change $LFS/tools's owner."
        exit 1
    fi

    chown -R root:root $LFS/tools

    # the user 'lfs' no longer need:
    userdel lfs
}

build
