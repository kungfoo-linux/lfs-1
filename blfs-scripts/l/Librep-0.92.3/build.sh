#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=librep-0.92.3.tar.xz
srcdir=librep-0.92.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libffi (>= 3.1)
Description: a lightweight Lisp environment
 The librep shared library implements a Lisp dialect that is lightweight,
 reasonably fast, and extensible. It contains an interpreter, byte-code
 compiler, and virtual machine. Applications may use the interpreter as an
 extension language, or it may be used for standalone scripts. The Lisp
 dialect was originally inspired by Emacs Lisp. Unlike Emacs Lisp, the
 reliance on dynamic scope has been removed and librep only has a single
 namespace for symbols.
 .
 [rep]
 is the Lisp interpreter.
 .
 [librep.so]
 contains the functions necessary for the Lisp interpreter.
EOF
}

build
