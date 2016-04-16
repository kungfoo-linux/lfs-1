#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gtk+-2.24.24.tar.xz
srcdir=gtk+-2.24.24
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i 's#l \(gtk-.*\).sgml#& -o \1#' docs/{faq,tutorial}/Makefile.in
sed -i 's#.*@man_#man_#' docs/reference/gtk/Makefile.in
sed -i -e 's#pltcheck.sh#$(NULL)#g' gtk/Makefile.in

./configure --prefix=/usr \
	--sysconfdir=/etc
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: ATK (>= 2.12.0), gdk-pixbuf (>= 2.30.8), Pango (>= 1.36.7), \
hicolor-icon-theme (>= 0.13), Cups (>= 1.7.5), \
gobject-introspection (>= 1.40.0)
Description: GTK+ graphical user interface library
 GTK+ is a multi-platform toolkit for creating graphical user interfaces.
 Offering a complete set of widgets, GTK+ is suitable for projects ranging
 from small one-off tools to complete application suites.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
gtk-query-immodules-2.0 --update-cache'
}

build
