#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gdb-7.8.tar.xz
srcdir=gdb-7.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--with-system-readline
make
make DESTDIR=$BUILDDIR -C gdb install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Python2 (>= 2.7.8)
Description: The GNU Debugger
 GDB, the GNU Project debugger, allows you to see what is going on “inside”
 another program while it executes -- or what another program was doing at the
 moment it crashed. Note that GDB is most effective when tracing programs and
 libraries that were built with debugging symbols and not stripped.
 .
 [gcore]
 generates a core dump of a running program.
 .
 [gdb]
 is the GNU Debugger.
 .
 [gdbserver]
 is a remote server for the GNU debugger (it allows programs to be debugged
 from a different machine).
 .
 [libinproctrace.so]
 contains functions for the in-process tracing agent. The agent allows for
 installing fast tracepoints, listing static tracepoint markers, probing
 static tracepoints markers, and starting trace monitoring.
EOF
}

build
