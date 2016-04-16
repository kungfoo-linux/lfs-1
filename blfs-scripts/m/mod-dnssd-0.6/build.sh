#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=mod_dnssd-0.6.tar.gz
srcdir=mod_dnssd-0.6
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i 's/unixd_setup_child/ap_&/' src/mod_dnssd.c

./configure --prefix=/usr \
	--disable-lynx
make
make install

mkdir -pv $BUILDDIR/usr/lib/httpd/modules
cp /usr/lib/httpd/modules/mod_dnssd.so \
	$BUILDDIR/usr/lib/httpd/modules

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Apache (>= 2.4.10), Avahi (>= 0.6.31)
Description: Zeroconf support for Apache 2 via avahi
 The mod_dnssd package is an Apache HTTPD module which adds Zeroconf support
 via DNS-SD using Avahi. This allows Apache to advertise itself and the
 websites available to clients compatible with the protocol.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
    pattern="^LoadModule dnssd_module"
    file=/etc/httpd/httpd.conf
    line="LoadModule dnssd_module /usr/lib/httpd/modules/mod_dnssd.so"
    addline_unique "$pattern" "$line" $file
    '

POSTRM_CONF_DEF='
    pattern="^LoadModule dnssd_module"
    file=/etc/httpd/httpd.conf
    delline "$pattern" $file
    '
}

build
