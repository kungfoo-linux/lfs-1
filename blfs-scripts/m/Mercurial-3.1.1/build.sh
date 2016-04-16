#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=mercurial-3.1.1.tar.gz
srcdir=mercurial-3.1.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make build
make DESTDIR=$BUILDDIR PREFIX=/usr install-bin

cleanup_src .. $srcdir
}

configure() {
install -v -d -m755 $BUILDDIR/etc/mercurial
cat > $BUILDDIR/etc/mercurial/hgrc << "EOF"
[web]
cacerts = /etc/ssl/ca-bundle.crt
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Python2 (>= 2.7.8), CA (= 7.6)
Description: a distributed source control management tool
 Mercurial is a distributed source control management tool similar to Git and
 Bazaar. Mercurial is written in Python and is used by projects such as
 Mozilla and Vim.
EOF
}

build
