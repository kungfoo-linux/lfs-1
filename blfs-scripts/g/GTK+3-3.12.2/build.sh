#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gtk+-3.12.2.tar.xz
srcdir=gtk+-3.12.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--enable-broadway-backend \
	--enable-x11-backend \
	--disable-wayland-backend
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: at-spi2-atk (>= 2.12.1), gdk-pixbuf (>= 2.30.8), Pango (>= 1.36.7), \
gobject-introspection (>= 1.40.0), Colord (>= 1.2.3), Cups (>= 1.7.5)
Description: GTK+ graphical user interface library
 GTK+ is a multi-platform toolkit for creating graphical user interfaces.
 Offering a complete set of widgets, GTK+ is suitable for projects ranging
 from small one-off tools to complete application suites.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
gtk-query-immodules-3.0 --update-cache
glib-compile-schemas /usr/share/glib-2.0/schemas'
}

build
