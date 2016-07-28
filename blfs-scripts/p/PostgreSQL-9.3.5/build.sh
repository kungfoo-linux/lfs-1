#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=postgresql-9.3.5.tar.bz2
srcdir=postgresql-9.3.5
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i '/DEFAULT_PGSOCKET_DIR/s@/tmp@/run/postgresql@' \
	src/include/pg_config_manual.h

./configure --prefix=/usr \
	--enable-thread-safety \
	--docdir=/usr/share/doc/postgresql-9.3.5 \
	--with-openssl
make

# There are a number of programs in the contrib/ directory. If you are going
# to run this installation as a server and wish to build some of them, enter
# make -C contrib or make -C contrib/<SUBDIR-NAME> for each subdirectory. 

make DESTDIR=$BUILDDIR install

gid=41
uid=41
install -v -dm700 $BUILDDIR/srv/pgsql/data
install -v -dm755 $BUILDDIR/run/postgresql
chown -Rv $uid:$gid $BUILDDIR/srv/pgsql $BUILDDIR/run/postgresql

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenSSL (>= 1.0.1i)
Description: object-relational SQL database
 PostgreSQL is a fully featured object-relational database management system.
 It supports a large part of the SQL standard and is designed to be extensible
 by users in many aspects.  Some of the features are: ACID transactions,
 foreign keys, views, sequences, subqueries, triggers, user-defined types and
 functions, outer joins, multiversion concurrency control. Graphical user
 interfaces and bindings for many programming languages are available as well.
 .
 Initialize a database cluster with the following commands issued by the root
 user:
     su - postgres -c '/usr/bin/initdb -D /srv/pgsql/data'
 .
 Modify the configure file /srv/pgsql/data/postgresql.conf, set
 "listen_addresses" to '*'.
 .
 Append a line to /srv/pgsql/data/pg_hba.conf:
     echo "host    all    all    0.0.0.0/0    md5" >> /srv/pgsql/data/pg_hba.conf
 .
 Start the database server with the following command by the root user:
     su - postgres -c '/usr/bin/postmaster -D /srv/pgsql/data > /srv/pgsql/data/logfile 2>&1 &'
 .
 Create a database (named "test") and a user (named "root"):
     su - postgres
     psql
     postgres=# create database test;
     postgres=# create user root with password 'secret' createdb;
     postgres=# \q
 .
 Stop database:
     su - postgres -c 'pg_ctl stop -D /srv/pgsql/data'
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	if ! getent group "postgres" > /dev/null 2>&1 ; then
	    groupadd -g 41 postgres
	fi

	if ! getent passwd "postgres" > /dev/null 2>&1 ; then
	    useradd -c "PostgreSQL Server" -g postgres -d /srv/pgsql/data \
		    -u 41 postgres 
	fi
	'

POSTRM_CONF_DEF='
	if getent passwd "postgres" > /dev/null 2>&1 ; then
	    userdel postgres
	fi

	if getent group "postgres" > /dev/null 2>&1 ; then
	    groupdel postgres
	fi
	'
}

build
