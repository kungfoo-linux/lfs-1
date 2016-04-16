#!/bin/bash -e
. ../../blfs.comm

build_src() {
case `uname -m` in
    i?86)
        srcfil=v10.5fp5_linuxia32_odbc_cli.tar.gz
	;;

    x86_64)
        srcfil=v10.5fp5_linuxx64_odbc_cli.tar.gz
	;;
esac
srcdir=odbc_cli

install -vdm755 $BUILDDIR/opt
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/linux/$srcfil -C $BUILDDIR/opt
mv -v $BUILDDIR/opt/{$srcdir,db2_odbc_cli}
#chown -R root:root $BUILDDIR/opt/db2_odbc_cli

strip_debug
}

configure() {
# db2cli.ini
cat > $BUILDDIR/opt/db2_odbc_cli/clidriver/cfg/db2cli.ini << "EOF"
[tstcli]
uid=userid
pwd=password
autocommit=0
TableType="'TABLE','VIEW','SYSTEM TABLE'"

[fmdb]
Database=WNMS
Protocol=TCPIP
Port=50000
Hostname=10.12.1.240
uid=fmdb
pwd=fmoptr
autocommit=0
TableType=\"'TABLE','VIEW','SYSTEM TABLE'\"
EOF

# db2.sh
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/db2.sh << "EOF"
export PATH=$PATH:/opt/db2_odbc_cli/clidriver/bin
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: DB2 ODBC driver
 Starting from DB2 Version 9.1, there is a separate stand alone CLI and ODBC
 driver called the IBM® Data Server Driver for ODBC and CLI. This driver is
 installed and configured separately and supports a subset of the
 functionality of the IBM Data Server Clients. It Provides runtime support
 for applications using CLI APIs, or ODBC APIs without the need of installing
 the Data Server Client or the Data Server Runtime Client. This driver is
 available only as a compressed file, not as an installable image. Messages
 are reported only in English.
 .
 Example configure:
 $ cat > /opt/db2_odbc_cli/clidriver/cfg/db2cli.ini << \"EOF\"
 ...
 [fmdb]
 Database=WNMS
 Protocol=TCPIP
 Port=50000
 Hostname=10.12.1.240
 uid=fmdb
 pwd=fmoptr
 autocommit=0
 TableType=\"'TABLE','VIEW','SYSTEM TABLE'\"
 ...
 EOF
 .
 Usage:
 $ db2cli execsql -execute -dsn fmdb
 > select 5 from dual;
 FetchAll:  Columns: 1
   1
   5
 > quit
 .
 unixODBC configure
 $ cat > /etc/unixODBC/odbcinst.ini << "EOF"
 ...
 [DB2]
 Description = DB2 ODBC driver
 Driver      = /opt/db2_odbc_cli/clidriver/lib/libdb2.so.1
 FileUsage   = 1
 Dontdlclose = 1
 ...
 EOF
 .
 $ cat > /etc/unixODBC/odbc.ini << "EOF"
 ...
 [fmdb]
 Description = DB2 database
 Driver      = DB2
 # other parameters used /opt/db2_odbc_cli/clidriver/cfg/db2cli.ini
 ...
 EOF
 .
 $ isql fmdb
      +-----------------------+
      | Connected!            |
      |                       |
      | sql-statement         |
      | quit                  |
      +-----------------------+
      SQL>
EOF
}

build
