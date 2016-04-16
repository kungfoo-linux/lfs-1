#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=ed-1.10.tar.lz
srcdir=ed-1.10
bsdtar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--bindir=/bin
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: a line-oriented text editor
 Ed is a line-oriented text editor. It is used to create, display, modify and
 otherwise manipulate text files, both interactively and via shell scripts. Ed
 isn't something which many people use. It's described here because it can be
 used by the patch program if you encounter an ed-based patch file. This
 happens rarely because diff-based patches are preferred these days.
EOF
}

build
