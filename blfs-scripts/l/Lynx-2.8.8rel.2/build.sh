#!/bin/bash -e
. ../../blfs.comm

build_src() {
# The sharutils-4.14 package offer a command called udecode, you'd better
# install sharutils-4.14 first.

srcfil=lynx2.8.8rel.2.tar.bz2
srcdir=lynx2-8-8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc/lynx \
	--datadir=/usr/share/doc/lynx-2.8.8rel.2 \
	--with-zlib \
	--with-bzlib \
	--with-screen=ncursesw \
	--enable-locale-charset \
	--enable-nls \
	--with-ssl
make
make DESTDIR=$BUILDDIR install-full
chgrp -v -R root $BUILDDIR/usr/share/doc/lynx-2.8.8rel.2/lynx_doc

cleanup_src .. $srcdir
}

configure() {
# Many other system-wide settings such as proxies can also be set in the
# /etc/lynx/lynx.cfg file.

sed -i 's/#\(LOCALE_CHARSET\):FALSE/\1:TRUE/' $BUILDDIR/etc/lynx/lynx.cfg
sed -i 's/#\(DEFAULT_EDITOR\):/\1:vi/' $BUILDDIR/etc/lynx/lynx.cfg
sed -i 's/#\(PERSISTENT_COOKIES\):FALSE/\1:TRUE/' $BUILDDIR/etc/lynx/lynx.cfg
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenSSL (>= 1.0.1), Zip (>= 3.0), UnZip (>= 6.0)
Description: text-mode WWW browser
 Lynx is a fully-featured World Wide Web (WWW) client for users running
 cursor-addressable, character-cell display devices. It is very fast and easy
 to use. It will display HTML documents containing links to files residing on
 the local system, as well as files residing on remote systems running Gopher,
 HTTP, FTP, WAIS, and NNTP servers.
 .
 [lynx]
 is a general purpose, text-based, distributed information browser for the
 World Wide Web.
EOF
}

build
