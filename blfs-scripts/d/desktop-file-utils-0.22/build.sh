#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=desktop-file-utils-0.22.tar.xz
srcdir=desktop-file-utils-0.22
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0)
Description: contains command line utilities for working with Desktop entries
 The Desktop File Utils package contains command line utilities for working
 with Desktop entries. These utilities are used by Desktop Environments and
 other applications to manipulate the MIME-types application databases and
 help adhere to the Desktop Entry Specification.
 .
 [desktop-file-edit]
 is used to modify an existing desktop file entry.
 .
 [desktop-file-install]
 is used to install a new desktop file entry. It is also used to rebuild or
 modify the MIME-types application database.
 .
 [desktop-file-validate]
 is used to verify the integrity of a desktop file.
 .
 [update-desktop-database]
 is used to update the MIME-types application database.
EOF
}

build
