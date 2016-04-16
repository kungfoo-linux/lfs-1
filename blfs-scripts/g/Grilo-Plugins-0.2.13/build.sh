#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=grilo-plugins-0.2.13.tar.xz
srcdir=grilo-plugins-0.2.13
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--enable-lua-factory
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Grilo (>= 0.2.11), SQLite (>= 3.8.6), libsoup (>= 2.46.0), \
gobject-introspection (>= 1.40.0), totem-pl-parser (>= 3.10.2), Lua (>= 5.2.3)
Description: Plugins for the Grilo framework
 Grilo-Plugins is a collection of plugins (Apple Trailers, Blip.tv, Bookmarks,
 Filesystem, Flickr, Jamendo, Magnatune, Rai.tv, Tracker, Youtube, between
 others) to make media discovery and browsing easy for applications that
 support Grilo framework, such as Totem (some plugins are disabled in Totem).
EOF
}

build
