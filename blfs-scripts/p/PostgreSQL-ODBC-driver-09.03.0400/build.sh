#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=psqlodbc-09.03.0400.tar.gz
srcdir=psqlodbc-09.03.0400

tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: PostgreSQL (>= 9.3.5), unixODBC (>= 2.3.2)
Description: PostgreSQL ODBC driver
 .
 Test:
 $ isql psql_local
      +-----------------------+
      | Connected!            |
      |                       |
      | sql-statement         |
      | help [tablename]      |
      | quit                  |
      +-----------------------+
      SQL>
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='
add_driver() {
    pattern="^\s*\[PostgreSQL\]\s*$"
    file=/etc/unixODBC/odbcinst.ini
    line="
[PostgreSQL]
Description = PostgreSQL ODBC driver
Driver      = /usr/lib/psqlodbcw.so"
    addline_unique "$pattern" "$line" $file
}

add_database() {
    pattern="^\s*\[psql_local\]\s*$"
    file=/etc/unixODBC/odbc.ini
    line="
[psql_local]
Driver          = PostgreSQL
Description     = PostgreSQL local database
Database        = test
Protocol        = 7.4
ReadOnly        = No
CommLog         = 
Servername      = localhost
Username        = root
Password        = secret"
    addline_unique "$pattern" "$line" $file
}
'

POSTRM_FUNC_DEF='
del_driver() {
    pattern_bgn="^\s*\[PostgreSQL\]\s*"
    pattern_end="\s*Driver.*"
    pattern_block=${pattern_bgn}"\nDescription\s*=.*\n"${pattern_end}
    file=/etc/unixODBC/odbcinst.ini
    delblock $pattern_bgn $pattern_end $pattern_block $file
}

del_database() {
    pattern_bgn="^\s*\[psql_local\]\s*"
    pattern_end="\s*Password\s*=.*"
    pattern_block=${pattern_bgn}"\n\s*Driver\s*=\s*PostgreSQL\s*\n.*"${pattern_end}
    file=/etc/unixODBC/odbc.ini
    delblock $pattern_bgn $pattern_end $pattern_block $file
}
'

POSTINST_CONF_DEF='
        add_driver
	add_database'

POSTRM_CONF_DEF='
        del_driver
	del_database'
}

build
