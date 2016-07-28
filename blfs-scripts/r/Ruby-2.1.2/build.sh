#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=ruby-2.1.2.tar.bz2
srcdir=ruby-2.1.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# this ruby's document use many disk space (70M), if you not use it often, add
# "--disable-install-doc" to disable it.

./configure --prefix=/usr \
	--enable-shared \
	--docdir=/usr/share/doc/ruby-2.1.2 \
	--disable-install-doc
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: BerkeleyDB (>= 6.1.19), OpenSSL (>= 1.0.1i)
Description: interpreter of object-oriented scripting language Ruby
 Ruby is the interpreted scripting language for quick and easy object-oriented
 programming.  It has many features to process text files and to do system
 management tasks (as in perl).  It is simple, straight-forward, and
 extensible.
EOF
}

build
