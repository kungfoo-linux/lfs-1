#!/bin/bash -e
. ../../blfs.comm

build_src() {
# This package does not support parallel build.

srcfil=slang-2.2.4.tar.bz2
srcdir=slang-2.2.4
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--with-readline=gnu
make -j1
make DESTDIR=$BUILDDIR install_doc_dir=/usr/share/doc/slang-2.2.4   \
	SLSH_DOC_DIR=/usr/share/doc/slang-2.2.4/slsh \
	install-all
chmod -v 755 $BUILDDIR/usr/lib/libslang.so.2.2.4 \
	$BUILDDIR/usr/lib/slang/v2/modules/*.so

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libpng (>= 1.6.13), PCRE (>= 8.35)
Description: S-Lang programming library
 S-Lang is an interpreted language that may be embedded into an application to
 make the application extensible. It provides facilities required by
 interactive applications such as display/screen management, keyboard input
 and keymaps.
 .
 [slsh]
 is a simple program for interpreting S-Lang scripts. It supports dynamic
 loading of S-Lang modules and includes a Readline interface for interactive
 use.
EOF
}

build
