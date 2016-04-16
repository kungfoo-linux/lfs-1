#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=cscope-15.8b.tar.gz
srcdir=cscope-15.8b
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make $JOBS
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: interactively examine a C program source
 Cscope is an interactive text screen based source browsing tool.
 Although it is primarily designed to search C code (including lex
 and yacc files), it can also be used for C++ code.
 .
 Using cscope, you can easily search for where symbols are used and
 defined. Cscope is designed to answer questions like:
 .
  - Where is this variable used?
  - What is the value of this preprocessor symbol?
  - Where is this function in the source files?
  - What functions call this function?
  - What functions are called by this function?
  - Where does the message "out of space" come from?
  - Where is this source file in the directory structure?
  - What files include this header file?
EOF
}

build
