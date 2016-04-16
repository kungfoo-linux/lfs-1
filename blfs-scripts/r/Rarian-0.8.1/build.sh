#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=rarian-0.8.1.tar.bz2
srcdir=rarian-0.8.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--localstatedir=/var
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libxslt (>= 1.1.28), docbook-xml (>= 4.5)
Description: documentation meta-data library
 The Rarian package is a documentation metadata library based on the proposed
 Freedesktop.org spec. Rarian is designed to be a replacement for
 ScrollKeeper.
 .
 [rarian-example]
 prints a nice list of all available documents found by the library.
 .
 [rarian-sk-config]
 emulates scrollkeeper-config.
 .
 [rarian-sk-extract]
 is a wrapper around xsltproc to mimic scrollkeeper-extract.
 .
 [rarian-sk-gen-uuid]
 generates a unique (random) uuid.
 .
 [rarian-sk-get-cl]
 gets a content list (category tree).
 .
 [rarian-sk-get-content-list]
 is a simple wrapper to make calling scrollkeeper-get-cl easier.
 .
 [rarian-sk-get-extended-content-list]
 is a simple wrapper to make calling scrollkeeper-get-cl (extended) easier.
 .
 [rarian-sk-get-scripts]
 emulates scrollkeeper-get-index-from-index-from-docpath,
 scrollkeeper-get-toc-from-docpath, and scrollkeeper-get-toc-from-id.
 .
 [rarian-sk-install]
 emulates scrollkeeper-install and scrollkeeper-uninstall.
 .
 [rarian-sk-migrate]
 takes in a directory full of omf's, reads and parses them and spews out an
 equivalent scroll file.
 .
 [rarian-sk-preinstall]
 creates the omf file by reading an existing omf file and replacing the url
 for a resource with the url.
 .
 [rarian-sk-rebuild]
 is a simple wrapper script to emulate scrollkeeper-rebuilddb.
 .
 [rarian-sk-update]
 is compatible with the scrollkeeper-update script that's required to
 be run when installing new omf files. It converts the omf files into
 new-style scrolls.
 .
 [librarian.{so,a}]
 is the API to build a list of available meta data files and allows
 access to these.
EOF
}

build
