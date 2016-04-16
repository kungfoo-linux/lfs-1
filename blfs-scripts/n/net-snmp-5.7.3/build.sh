#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=net-snmp-5.7.3.tar.gz
srcdir=net-snmp-5.7.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--with-logfile="/var/log/snmpd.log" \
	--with-persistent-directory="/var/net-snmp" \
	--with-default-snmp-version="2" \
	--with-sys-contact="smecf@163.com" \
	--with-sys-location="china"
make
make DESTDIR=$BUILDDIR install

mkdir -pv $BUILDDIR/etc/snmp
cp EXAMPLE.conf $BUILDDIR/etc/snmp/snmpd.conf

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Simple Network Management Protocol
 Simple Network Management Protocol (SNMP) is a widely used protocol for
 monitoring the health and welfare of network equipment (eg. routers),
 computer equipment and even devices like UPSs. Net-SNMP is a suite of
 applications used to implement SNMP v1, SNMP v2c and SNMP v3 using both IPv4
 and IPv6.
EOF
}

build
