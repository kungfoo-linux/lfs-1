#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=cpulimit-2.2.tar.gz
srcdir=cpulimit-2.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make
make PREFIX=$BUILDDIR/usr install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: tool for limiting the CPU usage of a process
 cpulimit is a simple program that attempts to limit the CPU usage of a
 process (expressed in percentage, not in CPU time). This is useful to control
 batch jobs, when you don't want them to eat too much CPU. It does not act on
 the nice value or other priority stuff, but on the real CPU usage.  Besides
 it is able to adapt itself to the overall system load, dynamically and
 quickly.
 .
 example (limit the process which PID is 1167 use 50% CPU resource):
 cpulimit -p 1167 -l 50
EOF
}

build
