#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=unixODBC-2.3.2.tar.gz
srcdir=unixODBC-2.3.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc/unixODBC
make
make DESTDIR=$BUILDDIR install

find doc -name "Makefile*" -delete
chmod 644 doc/{lst,ProgrammerManual/Tutorial}/*
install -v -m755 -d $BUILDDIR/usr/share/doc/unixODBC-2.3.2
cp      -v -R doc/* $BUILDDIR/usr/share/doc/unixODBC-2.3.2

cat /dev/null > $BUILDDIR/etc/unixODBC/odbcinst.ini
cat /dev/null > $BUILDDIR/etc/unixODBC/odbc.ini

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: A complete ODBC driver manager for Linux
 The unixODBC package is an Open Source ODBC (Open DataBase Connectivity)
 sub-system and an ODBC SDK for Linux, Mac OSX, and UNIX. ODBC is an open
 specification for providing application developers with a predictable API
 with which to access data sources. Data sources include optional SQL Servers
 and any data source with an ODBC Driver. unixODBC contains the following
 components used to assist with the manipulation of ODBC data sources: a
 driver manager, an installer library and command line tool, command line
 tools to help install a driver and work with SQL, drivers and driver setup
 libraries.
 .
 unixODBC is an ODBC driver manager. An ODBC driver manager is a library that
 manages communication between the ODBC-aware and any drivers. It's main
 functionality includes:
  [*] Resolving Data Source Names(DSN).
  [*] Driver loading and unloading.
  [*] Processing ODBC function calls or passing them to the driver.
 .
 Usage:
 .
 print unixODBC config info:
      odbcinst -j
 .
 [dltest]
 is a utility used to check a share library to see if it can be loaded and if
 a given symbol exists in it.
 .
 [isql]
 is an utility which can be used to submit SQL to a data source and to
 format/output results. It can be used in batch or interactive mode.
 .
 [iusql]
 provides the same functionality as the isql program.
 .
 [odbc_config]
 is used to find out details about the installation of the unixODBC package.
 .
 [odbcinst]
 is an utility created for install script/RPM writers. It is a command line
 interface to key functionality in the libodbcinst library. It does not copy
 any files (i.e., libraries) but it will modify the ODBC System Information
 for the user.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	pattern="^\s*export\s\+ODBCINI="
        file=/etc/profile
	line="export ODBCINI=/etc/unixODBC/odbc.ini"
        addline_unique "$pattern" "$line" $file
	'

POSTRM_CONF_DEF='
	pattern="^export\s\+ODBCINI="
        file=/etc/profile
	delline "$pattern" $file
	'
}

build
