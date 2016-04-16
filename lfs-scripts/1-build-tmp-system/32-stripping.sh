#!/bin/bash
. ../lfs.comm

configure() {
    # The steps in this section are optional, but if the LFS partition is
    # rather small, it is beneficial to learn that unnecessary items can be
    # removed. The executables and libraries built so far contain about 70
    # MB of unneeded debugging symbols. Remove those symbols with:
    strip --strip-debug /tools/lib/*
    /usr/bin/strip --strip-unneeded /tools/{,s}bin/*

    # At this point, you should have at least 1 GB of free space in $LFS
    # that can be used to build and install Glibc and Gcc in the next phase.
    # If you can build and install Glibc, you can build and install the rest
    # too. 

    # exit from lfs to root user
    #exec kill -9 $PPID
    echo -e "\nPlease exit to root user\n"
}

build
