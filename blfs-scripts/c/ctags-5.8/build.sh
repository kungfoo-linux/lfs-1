#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=ctags-5.8.tar.gz
srcdir=ctags-5.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr CFLAGS=-O2
make
make prefix=$BUILDDIR/usr install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: build tag file indexes of source code definitions
 ctags parses source code and produces a sort of index mapping the names of
 significant entities (e.g. functions, classes, variables) to the location
 where that entity is defined. This index is used by editors like vi and
 emacsen to allow moving to the definition of a user-specified entity.
 .
 Exuberant Ctags supports all possible C language constructions and multiple
 other languages such as assembler, AWK, ASP, BETA, Bourne/Korn/Z shell, C++,
 COBOL, Eiffel, Fortran, Java, Lisp, Lua, Makefile, Pascal, Perl, PHP, Python,
 REXX, Ruby, S-Lang, Scheme, Tcl, Verilog, Vim and YACC.
EOF
}

build
