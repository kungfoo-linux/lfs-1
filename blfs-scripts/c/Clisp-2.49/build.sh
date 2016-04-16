#!/bin/bash -e
. ../../blfs.comm

build_src() {
# This package does not support parallel build.

srcfil=clisp-2.49.tar.bz2
srcdir=clisp-2.49
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir build && cd build
../configure --srcdir=../ \
	--prefix=/usr \
	--docdir=/usr/share/doc/clisp-2.49 \
	--with-libsigsegv-prefix=/usr
ulimit -s 16384
make -j1
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libsigsegv (>= 2.10)
Description: GNU CLISP, a Common Lisp implementation
 GNU Clisp is a Common Lisp implementation which includes an interpreter,
 compiler, debugger, and many extensions.
 .
 [clisp]
 is an ANSI Common Lisp compiler, interpreter, and debugger.
 .
 [clisp-link]
 is used to link an external module to clisp.
EOF
}

build
