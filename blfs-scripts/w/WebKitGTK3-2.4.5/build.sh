#!/bin/bash -e
. ../../blfs.comm

build_against_gtk3() {
mkdir -pv build-3
cp -a Documentation build-3
pushd build-3

../configure --prefix=/usr \
	--enable-introspection
make
make DESTDIR=$BUILDDIR install

popd
}

build_against_gtk2() {
mkdir -pv build-1
pushd build-1

../configure --prefix=/usr \
	--with-gtk=2.0 \
	--disable-webkit2
make
make DESTDIR=$BUILDDIR install

popd
}

build_src() {
srcfil=webkitgtk-2.4.5.tar.xz
srcdir=webkitgtk-2.4.5
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# If you have not installed GTK-Doc-1.20, fix a bug that will cause make
# install to fail:
sed -i '/generate-gtkdoc --rebase/s:^:# :' GNUmakefile.in

# Build and install WebKitGTK+ against GTK+ 3:
build_against_gtk3

# Build and install WebKitGTK+ against GTK+ 2:
build_against_gtk2

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: gst-plugins-base1 (>= 1.4.1), GTK+2 (>= 2.24.24), \
GTK+3 (>= 3.12.2), ICU (>= 53.1), libsecret (>= 0.18), libsoup (>= 2.46.0), \
libwebp (>= 0.4.1), MesaLib (>= 10.2.7), Ruby (>= 1.8.7), SQLite (>= 3.8.6), \
eudev (>= 1.10), Which (>= 2.20)
Recommends: enchant (>= 1.6.0), GeoClue (>= 0.12.0), \
gobject-introspection (>= 1.40.0), hicolor-icon-theme (>= 0.13)
Suggests: Harfbuzz (>= 0.9.35), LLVM (>= 3.5.0)
Description: GTK+ Web content engine library
 The WebKitGTK+ is the port of the portable web rendering engine WebKit to the
 GTK+ 3 and/or GTK+ 2 platforms.
EOF
}

build
