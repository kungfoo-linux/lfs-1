#!/bin/bash -e
. ../../blfs.comm

build_src() {
# For build this package, need the Boost's header files.

srcfil=valgrind-3.10.0.tar.bz2
srcdir=valgrind-3.10.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i 's|/doc/valgrind||' docs/Makefile.in

./configure --prefix=/usr \
	--datadir=/usr/share/doc/valgrind-3.10.0
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: memory debugger and profiler
 Valgrind is an instrumentation framework for building dynamic analysis tools.
 There are Valgrind tools that can automatically detect many memory management
 and threading bugs, and profile programs in detail. Valgrind can also be used
 to build new tools.
 .
 [valgrind]
 is a program for debugging and profiling Linux executables.
 .
 [callgrind_annotate]
 takes an output file produced by the Valgrind tool Callgrind and prints the
 information in an easy-to-read form.
 .
 [callgrind_control]
 controls programs being run by the Valgrind tool Callgrind.
 .
 [cg_annotate]
 is a post-processing tool for the Valgrind tool Cachegrind.
 .
 [cg_diff]
 compares two Cachegrind output files.
 .
 [cg_merge]
 merges multiple Cachegrind output files into one.
 .
 [ms_print]
 takes an output file produced by the Valgrind tool Massif and prints the
 information in an easy-to-read form.
 .
 [valgrind-di-server]
 is a server that reads debuginfo from objects stored on a different machine.
 .
 [valgrind-listener]
 listens on a socket for Valgrind commentary.
 .
 [vgdb]
 is an intermediary between Valgrind and GDB or a shell.
EOF
}

build
