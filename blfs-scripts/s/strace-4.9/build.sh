#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=strace-4.9.tar.xz
srcdir=strace-4.9
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: A system call tracer
 .
 Usage example
 * run test, trace close system call and put the message into output.txt:
      strace -o /tmp/output.txt -e close ./test
 * Attach the process 1330, trace close system call and put the message into
   output.txt:
      strace -o /tmp/output.txt -e close -p 1330
EOF
}

build
