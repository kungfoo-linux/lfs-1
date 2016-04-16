#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=yasm-1.3.0.tar.gz
srcdir=yasm-1.3.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# This sed prevents it compiling 2 programs (vsyasm and ytasm) that are 
# only of use on Microsoft Windows:
sed -i 's#) ytasm.*#)#' Makefile.in

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: modular assembler with multiple syntaxes support
 Yasm is a complete rewrite of the NASM assembler. It supports the x86 and 
 AMD64 instruction sets, accepts NASM and GAS assembler syntaxes and outputs 
 binary, ELF32 and ELF64 object formats.
 .
 [yasm] is a portable, retargetable assembler that supports the x86 and AMD64
 instruction sets, accepts NASM and GAS assembler syntaxes and outputs 
 binaries in ELF32 and ELF64 object formats.
 .
 [libyasm.a] provides all of the core functionality of yasm, for 
 manipulating machine instructions and object file constructs. 
EOF
}

build
