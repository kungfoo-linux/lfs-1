#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xapian-core-1.2.17.tar.xz
srcdir=xapian-core-1.2.17
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
Description: an open source search engine library
 Xapian is an Open Source Search Engine Library, released under the GPL. It's
 written in C++, with bindings to allow use from Perl, Python, PHP, Java, Tcl,
 C#, and Ruby (so far!) Xapian is a highly adaptable toolkit which allows
 developers to easily add advanced indexing and search facilities to their own
 applications. It supports the Probabilistic Information Retrieval model and
 also supports a rich set of boolean query operators.
EOF
}

build
