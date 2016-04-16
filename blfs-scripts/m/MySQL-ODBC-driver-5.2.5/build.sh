#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=mysql-connector-odbc-5.2.5-src.tar.gz
srcdir=mysql-connector-odbc-5.2.5-src

tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

cmake -G "Unix Makefiles" \
	-DWITH_UNIXODBC=1 \
	-DDISABLE_GUI=1 \
	.
make

mkdir -pv $BUILDDIR/usr/lib
cp lib/libmyodbc5w.so $BUILDDIR/usr/lib

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: MySQL (>= 5.1.73), unixODBC (>= 2.3.2)
Description: MySQL ODBC driver
 .
 Test:
 $ isql mysql_local
      +-----------------------+
      | Connected!            |
      |                       |
      | sql-statement         |
      | quit                  |
      +-----------------------+
      SQL>
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='
add_driver() {
    pattern="^\s*\[MySQL\]\s*$"
    file=/etc/unixODBC/odbcinst.ini
    line="
[MySQL]
Description = MySQL ODBC driver
Driver      = /usr/lib/libmyodbc5w.so"
    addline_unique "$pattern" "$line" $file
}

add_data_source() {
    pattern="^\s*\[ODBC\s\+Data\s\+Sources\]\s*$"
    file=/etc/unixODBC/odbc.ini
    line="
[ODBC Data Sources]
data_source_name = mysql_local"
    addline_unique "$pattern" "$line" $file
}

add_database() {
    pattern="^\s*\[mysql_local\]\s*$"
    file=/etc/unixODBC/odbc.ini
    line="
[mysql_local]
Driver 		= MySQL
DATABASE        = test
SERVER          = localhost
UID             = root
PASSWORD        = Fangxm
SOCKET		="
    addline_unique "$pattern" "$line" $file
}
'

POSTRM_FUNC_DEF='
del_driver() {
    pattern_bgn="^\s*\[MySQL\]\s*"
    pattern_end="\s*Driver.*"
    pattern_block=${pattern_bgn}"\nDescription\s*=.*\n"${pattern_end}
    file=/etc/unixODBC/odbcinst.ini
    delblock $pattern_bgn $pattern_end $pattern_block $file
}

del_data_source() {
    pattern_bgn="^\s*\[ODBC\s\+Data\s\+Sources\]\s*"
    pattern_end="\s*data_source_name\s*=\s*mysql_local\s*"
    pattern_block=${pattern_bgn}"\n"${pattern_end}
    file=/etc/unixODBC/odbc.ini
    delblock $pattern_bgn $pattern_end $pattern_block $file
}

del_database() {
    pattern_bgn="^\s*\[mysql_local\]\s*"
    pattern_end="\s*SOCKET\s*=.*"
    pattern_block=${pattern_bgn}"\n\s*Driver\s*=\s*MySQL\s*\n.*"${pattern_end}
    file=/etc/unixODBC/odbc.ini
    delblock $pattern_bgn $pattern_end $pattern_block $file
}
'

POSTINST_CONF_DEF='
        add_driver
	add_data_source
	add_database'

POSTRM_CONF_DEF='
        del_driver
	del_data_source
	del_database'
}

build
