#!/bin/bash -e
. ../../blfs.comm

build_src() {
case `uname -m` in
    i?86)
	arch=linux-x86
	suffix=
	;;

    x86_64)
	arch=linux-x86_64
	suffix=-x64
	;;
esac

mkdir -pv $BUILDDIR/opt/oracle
unzip_dir="-d $BUILDDIR/opt/oracle"
unzip $BLFSSRC/$PKGLETTER/$CURDIR/$arch/basiclite-10.2.0.5.0-linux${suffix}.zip $unzip_dir
unzip $BLFSSRC/$PKGLETTER/$CURDIR/$arch/sqlplus-10.2.0.5.0-linux${suffix}.zip $unzip_dir
unzip $BLFSSRC/$PKGLETTER/$CURDIR/$arch/sdk-10.2.0.5.0-linux${suffix}.zip $unzip_dir
unzip $BLFSSRC/$PKGLETTER/$CURDIR/$arch/odbc-10.2.0.5.0-linux${suffix}.zip $unzip_dir
mv -v $BUILDDIR/opt/oracle/{instantclient_10_2,client}

mkdir -pv $BUILDDIR/usr/lib
ln -sfv /opt/oracle/client/libclntsh.so.10.1 $BUILDDIR/usr/lib/
ln -sfv libodbcinst.so.2.0.0 $BUILDDIR/usr/lib/libodbcinst.so.1

cleanup_src . $srcdir
}

configure() {
# oracle.sh
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/oracle.sh << "EOF"
export ORACLE_HOME=/opt/oracle/product/10.2.0/db_1
export ORACLE_SID=orcl
export TNS_ADMIN=/opt/oracle/tnsadmin
export PATH=$PATH:$ORACLE_HOME/bin:/opt/oracle/client
EOF

# Create tnsnames.ora:
mkdir -pv $BUILDDIR/opt/oracle/tnsadmin
cat > $BUILDDIR/opt/oracle/tnsadmin/tnsnames.ora << "EOF"
local =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 127.0.0.1)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = orcl)
    )
  )
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: unixODBC (>= 2.3.2)
Description: Oracle Database Instant Client
 Instant Client allows you to run your applications without installing the
 standard Oracle client or having an ORACLE_HOME. OCI, OCCI, Pro*C, ODBC, and
 JDBC applications work without modification, while using significantly less
 disk space than before. Even SQL*Plus can be used with Instant Client. No
 recompile, no hassle.
 .
 Test:
 $ isql oracle_local root secret -v
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
add_ld_conf() {
    pattern="^\s*\/opt\/oracle\/client\s*$"
    file=/etc/ld.so.conf
    line="/opt/oracle/client"
    addline_unique "$pattern" "$line" $file
    ldconfig
}

add_driver() {
    pattern="^\s*\[Oracle\]\s*$"
    file=/etc/unixODBC/odbcinst.ini
    line="
[Oracle]
Description = Oracle ODBC driver
Driver      = /opt/oracle/client/libsqora.so.10.1"
    addline_unique "$pattern" "$line" $file
}

add_database() {
    pattern="^\s*\[oracle_local\]\s*$"
    file=/etc/unixODBC/odbc.ini
    line="
[oracle_local]
Driver 		= Oracle
Description     = local Oracle database
Database        = orcl
Servername	= local"
    addline_unique "$pattern" "$line" $file
}
'

POSTRM_FUNC_DEF='
del_ld_conf() {
    pattern="^\s*\/opt\/oracle\/client\s*$"
    file=/etc/ld.so.conf
    delline "$pattern" $file
}

del_driver() {
    pattern_bgn="^\s*\[Oracle\]\s*"
    pattern_end="\s*Driver.*"
    pattern_block=${pattern_bgn}"\nDescription\s*=.*\n"${pattern_end}
    file=/etc/unixODBC/odbcinst.ini
    delblock $pattern_bgn $pattern_end $pattern_block $file
}

del_database() {
    pattern_bgn="^\s*\[oracle_local\]\s*"
    pattern_end="\s*Servername\s*=.*"
    pattern_block=${pattern_bgn}"\n\s*Driver\s*=\s*Oracle\s*\n.*"${pattern_end}
    file=/etc/unixODBC/odbc.ini
    delblock $pattern_bgn $pattern_end $pattern_block $file
}
'

POSTINST_CONF_DEF='
        add_ld_conf
        add_driver
	add_database'

POSTRM_CONF_DEF='
        del_ld_conf
        del_driver
	del_database'
}

build
