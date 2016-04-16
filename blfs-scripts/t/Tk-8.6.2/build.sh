#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=tk8.6.2-src.tar.gz
srcdir=tk8.6.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir/unix


./configure --prefix=/usr \
	--mandir=/usr/share/man \
	$([ $(uname -m) = x86_64 ] && echo --enable-64bit)
make

sed -e "s@^\(TK_SRC_DIR='\).*@\1/usr/include'@" \
    -e "/TK_B/s@='\(-L\)\?.*unix@='\1/usr/lib@" \
    -i tkConfig.sh

make DESTDIR=$BUILDDIR install
make DESTDIR=$BUILDDIR install-private-headers
ln -svf wish8.6 $BUILDDIR/usr/bin/wish
chmod -v 755 $BUILDDIR/usr/lib/libtk8.6.so

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Tcl (>= 8.6.2), Xorg-lib (>= 7.7)
Description: TCL GUI Toolkit
 .
 [wish]
 is a symlink to the wish8.6 program.
 .
 [wish8.6]
 is a simple shell containing the Tk toolkit that creates a main window and
 then processes Tcl commands.
 .
 [libtk8.6.so]
 contains the API functions required by Tk. 
EOF
}

build
