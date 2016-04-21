#!/bin/bash -e
. ../../blfs.comm

build_src() {
    version=4.1.4
    srcfil=zeromq-$version.tar.gz
    srcdir=zeromq-$version
    tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
    cd $srcdir
    
    ./configure --prefix=/usr \
        --enable-static \
        --without-libsodium \
        --without-libgssapi_krb5 \
        --without-pgm \
        --without-norm
    make $JOBS
    make DESTDIR=$BUILDDIR install
    
    cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: lightweight messaging kernel
 ØMQ is a library which extends the standard socket interfaces with features
 traditionally provided by specialised messaging middleware products.
 .
 ØMQ sockets provide an abstraction of asynchronous message queues, multiple
 messaging patterns, message filtering (subscriptions), seamless access to
 multiple transport protocols and more.
EOF
}

build
