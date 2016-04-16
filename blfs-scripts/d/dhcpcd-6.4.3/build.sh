#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=dhcpcd-6.4.3.tar.bz2
srcdir=dhcpcd-6.4.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --libexecdir=/lib/dhcpcd \
	--dbdir=/var/tmp
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

configure() {
# you need to install the network service script, /lib/services/dhcpcd
# included in the blfs-bootscripts-20140919 package:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-service-dhcpcd
popd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: an implementation of the DHCP client specified in RFC2131
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
        [ -f /etc/sysconfig/ifconfig.eth0 ] && \
		mv -v /etc/sysconfig/{,NOUSE.}ifconfig.eth0

cat > /etc/sysconfig/ifconfig.eth0 << "EOF"
ONBOOT=yes
IFACE=eth0
SERVICE=dhcpcd
DHCP_START="-b -q"
DHCP_STOP="-k"
EOF
'

POSTRM_CONF_DEF='
        [ -f /etc/sysconfig/NOUSE.ifconfig.eth0 ] && \
		mv -v /etc/sysconfig/{NOUSE.,}ifconfig.eth0
	'
}

build
