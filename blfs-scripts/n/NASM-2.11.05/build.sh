#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=nasm-2.11.05.tar.xz
srcdir=nasm-2.11.05
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/nasm-2.11.05-xdoc.tar.xz \
	--strip-components=1

./configure --prefix=/usr
make
make INSTALLROOT=$BUILDDIR install

install -m755 -d         $BUILDDIR/usr/share/{doc/nasm-2.11.05/html,info}
cp -v doc/html/*.html    $BUILDDIR/usr/share/doc/nasm-2.11.05/html
cp -v doc/*.{txt,ps,pdf} $BUILDDIR/usr/share/doc/nasm-2.11.05
cp -v doc/info/*         $BUILDDIR/usr/share/info

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Homepage: http://www.nasm.us
Description: General-purpose x86 assembler
 NASM (Netwide Assembler) is an 80x86 assembler designed for portability and
 modularity. It includes a disassembler as well.
 .
 [nasm]
 is a portable 80x86 assembler.
 .
 [ndisasm]
 is an 80x86 binary file disassembler.
EOF
}

build
