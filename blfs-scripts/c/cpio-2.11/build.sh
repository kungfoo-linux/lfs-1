#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=cpio-2.11.tar.bz2
srcdir=cpio-2.11
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i -e '/gets is a/d' gnu/stdio.in.h
./configure --prefix=/usr \
	--bindir=/bin \
	--enable-mt \
	--with-rmt=/usr/libexec/rmt
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: a GNU archiving program
 GNU cpio copies files into or out of a cpio or tar archive. The archive can
 be another file on the disk, a magnetic tape, or a pipe.
 GNU cpio supports the following archive formats: binary, old ASCII,
 new ASCII, crc, HPUX binary, HPUX old ASCII, old tar, and POSIX.1 tar.
 The tar format is provided for compatability with the tar program. By
 default, cpio creates binary format archives, for compatibility with older
 cpio programs. When extracting from archives, cpio automatically recognizes
 which kind of archive it is reading and can read archives created on
 machines with a different byte-order.
 .
 [cpio]
 copies files to and from archives.
 .
 [mt]
 controls magnetic tape drive operations. 
EOF
}

build
