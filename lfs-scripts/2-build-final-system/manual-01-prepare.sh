#!/bin/bash -e
LFS=/lfs
. ../lfs.comm

# Preparing Virtual Kernel File Systems
prepare_virtual_kernel_fs() {
    # Begin by creating directories onto which the file system will be mounted
    mkdir -pv $LFS/{dev,proc,sys,run}

    # Creating initial device nodes
    if [ ! -c $LFS/dev/console ]; then
        mknod -m 600 $LFS/dev/console c 5 1
    fi
    if [ ! -c $LFS/dev/null ]; then
        mknod -m 666 $LFS/dev/null c 1 3
    fi

    # Mounting and populating /dev
    mount -v --bind /dev $LFS/dev

    # Mounting virtual kernel file systems
    mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
    if [ ! -d $LFS/proc/1 ]; then
        mount -vt proc proc $LFS/proc
    fi
    if [ ! -d $LFS/sys/kernel ]; then
        mount -vt sysfs sysfs $LFS/sys
    fi
    mount -vt tmpfs tmpfs $LFS/run

    # In some host systems, /dev/shm is a symbolic link to /run/shm.
    # The /run tmpfs was mounted above so in this case only a directory
    # needs to be create.
    if [ -h $LFS/dev/shm ]; then
        mkdir -pv $LFS/$(readlink $LFS/dev/shm)
    fi
}

# Entering the Chroot Environment
enter_chroot() {
    chroot "$LFS" /tools/bin/env -i \
        HOME=/root \
        TERM="$TERM" \
        PS1='lfs7.6# ' \
        PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
        /tools/bin/bash --login +h
}

# Preparing for building the LFS system
configure() {
    # verify user ID
    if [ $UID != 0 ]; then
        echo "need root user to build final system."
        exit 1
    fi

    prepare_virtual_kernel_fs
    enter_chroot
}

build
