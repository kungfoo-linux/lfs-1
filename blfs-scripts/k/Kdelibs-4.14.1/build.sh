#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=kdelibs-4.14.1.tar.xz
srcdir=kdelibs-4.14.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i "s@{SYSCONF_INSTALL_DIR}/xdg/menus@& RENAME kde-applications.menu@" \
	kded/CMakeLists.txt
sed -i "s@applications.menu@kde-&@" \
        kded/kbuildsycoca.cpp

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
	-DSYSCONF_INSTALL_DIR=/etc \
	-DCMAKE_BUILD_TYPE=Release \
	-DDOCBOOKXML_CURRENTDTD_DIR=/usr/share/xml/docbook/xml-dtd-4.5 \
	-DWITH_SOLID_UDISKS2=TRUE \
	-Wno-dev \
	..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Attica (>= 0.4.2), docbook-xml (>= 4.5), docbook-xsl (>= 1.78.1), \
giflib (>= 5.1.0), libdbusmenu-qt (>= 0.9.2), libjpeg-turbo (>= 1.3.1), \
libpng (<= 1.6.13), phonon (>= 4.8.0), strigi (>= 0.7.8), \
shared-mime-info (>= 1.3)
Recommends: polkit-qt (>= 0.112.0), OpenSSL (>= 1.0.1i), qca (>= 2.0.3), \
UPower (>= 0.9.23), UDisks2 (>= 2.1.3)
Suggests: JasPer (>= 1.900.1), PCRE (>= 8.35), Avahi (>= 0.6.31), \
Aspell (>= 0.60.6.1), enchant (>= 1.6.0), grantlee (>= 0.4.0)
Description: The KDE Libraries
EOF
}

build
