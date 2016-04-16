#!/bin/bash -e
. ../lfs.comm

# The Inetutils package contains programs for basic networking.

build_src() {
    srcfil=inetutils-1.9.2.tar.gz
    srcdir=inetutils-1.9.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    # Create a definition to allow the ifconfig program to build properly:
    echo '#define PATH_PROCNET_DEV "/proc/net/dev"' >> ifconfig/system/linux.h

    ./configure --prefix=/usr \
        --localstatedir=/var \
        --disable-logger \
        --disable-whois \
        --disable-servers
    make -j$JOBS
    make check
    make install

    # Move some programs to their FHS-compliant place:
    mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
    mv -v /usr/bin/ifconfig /sbin

    cd .. && rm -rf $srcdir
}

build
