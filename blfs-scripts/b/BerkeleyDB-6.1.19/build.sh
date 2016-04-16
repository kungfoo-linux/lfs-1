#!/bin/bash -e
. ../../blfs.comm

build_src() {
# The sharutils-4.14 package offer a command called udecode, you'd better
# install sharutils-4.14 first.

srcfil=db-6.1.19.tar.gz
srcdir=db-6.1.19
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir/build_unix

../dist/configure --prefix=/usr \
	--enable-compat185 \
	--enable-dbm \
	--disable-static \
	--enable-cxx \
	--enable-tcl --with-tcl=/usr/lib
make
make DESTDIR=$BUILDDIR docdir=/usr/share/doc/db-6.1.19 install

chown -v -R root:root \
	$BUILDDIR/usr/bin/db_* \
	$BUILDDIR/usr/include/db{,_185,_cxx}.h \
	$BUILDDIR/usr/lib/libdb*.{so,la} \
	$BUILDDIR/usr/share/doc/db-6.1.19

# The $BUILDDIR/usr/share/doc/db-6.1.19 take up many disk space (98M), if you
# not use it often, you can delete it.
rm -rf $BUILDDIR/usr/share

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Tcl (>= 8.6.2)
Description: Berkeley Database
 The Berkeley DB package contains programs and utilities used by many other
 applications for database related functions.
 .
 [db_archive]
 prints the pathnames of log files that are no longer in use.
 .
 [db_checkpoint]
 is a daemon process used to monitor and checkpoint database logs.
 .
 [db_deadlock]
 is used to abort lock requests when deadlocks are detected.
 .
 [db_dump]
 converts database files to a flat file format readable by db_load.
 .
 [db_hotbackup]
 creates "hot backup" or "hot failover" snapshots of Berkeley DB databases.
 .
 [db_load]
 is used to create database files from flat files created with db_dump.
 .
 [db_log_verify]
 verifies the log files of a database.
 .
 [db_printlog]
 converts database log files to human readable text.
 .
 [db_recover]
 is used to restore a database to a consistent state after a failure.
 .
 [db_replicate]
 is a daemon process that provides replication/HA services on a transactional
 environment.
 .
 [db_stat]
 displays database environment statistics.
 .
 [db_tuner]
 analyzes the data in a btree database, and suggests a page size that is
 likely to deliver optimal operation.
 .
 [db_upgrade]
 is used to upgrade database files to a newer version of Berkeley DB.
 .
 [db_verify]
 is used to run consistency checks on database files.
EOF
}

build
