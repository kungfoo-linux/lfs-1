#!/bin/bash -e
. ../lfs.comm

strip_files() {
    export PATH=/bin:/usr/bin:/sbin:/usr/sbin
    /tools/bin/find /{,usr/}{bin,lib,sbin} -type f \
        -exec /tools/bin/strip --strip-debug '{}' ';'
    rm -rf /tmp/*
    #rm -rf /tools
}

enter_another_chroot() {
    chroot / /usr/bin/env -i \
        HOME=/root \
        TERM="$TERM" \
        PS1='lfs7.6# ' \
        PATH=/bin:/usr/bin:/sbin:/usr/sbin \
        /bin/bash --login
}

build_src() {
    strip_files
    enter_another_chroot
}

build
