#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libiodbc-3.52.9.tar.gz
srcdir=libiodbc-3.52.9
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--with-iodbc-inidir=/etc/iodbc \
	--includedir=/usr/include/iodbc \
	--disable-static \
	--disable-libodbc
make
make DESTDIR=$BUILDDIR install

mkdir -pv $BUILDDIR/etc/iodbc/ODBCDataSources
touch $BUILDDIR/etc/iodbc/{odbcinst.ini,odbc.ini}
cp -v etc/odbc*.ini.sample $BUILDDIR/etc/iodbc

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Recommends: GTK+2 (>= 2.24.24)
Description: an API to ODBC compatible databases
 .
 [iodbc-config]
 is a utility for retrieving the installation options of libiodbc.
 .
 [iodbctest{,w}]
 are interactive SQL processors.
 .
 [iodbcadm]
 is a graphical administration utility.
EOF
}

build
