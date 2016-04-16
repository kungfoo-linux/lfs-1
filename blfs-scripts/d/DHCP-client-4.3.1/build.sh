#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=dhcp-4.3.1.tar.gz
srcdir=dhcp-4.3.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# If you have not compiled IPv6 support into the kernel, apply the
# missing_ipv6 patch:
#     patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/dhcp-4.3.1-missing_ipv6-1.patch

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/dhcp-4.3.1-client_script-1.patch

CFLAGS="-D_PATH_DHCLIENT_SCRIPT='\"/sbin/dhclient-script\"'     \
        -D_PATH_DHCPD_CONF='\"/etc/dhcp/dhcpd.conf\"'           \
        -D_PATH_DHCLIENT_CONF='\"/etc/dhcp/dhclient.conf\"'"    \
./configure --prefix=/usr                                       \
	--sysconfdir=/etc/dhcp                                  \
	--localstatedir=/var                                    \
	--with-srv-lease-file=/var/lib/dhcpd/dhcpd.leases       \
	--with-srv6-lease-file=/var/lib/dhcpd/dhcpd6.leases     \
	--with-cli-lease-file=/var/lib/dhclient/dhclient.leases \
	--with-cli6-lease-file=/var/lib/dhclient/dhclient6.leases
make

# Install the ISC DHCP client only:
make DESTDIR=$BUILDDIR -C client install

mv -v $BUILDDIR/usr/sbin $BUILDDIR
install -v -m755 client/scripts/linux $BUILDDIR/sbin/dhclient-script

cleanup_src .. $srcdir
}

configure() {
cat > $BUILDDIR/etc/dhcp/dhclient.conf << "EOF"
# Begin /etc/dhcp/dhclient.conf
#
# Basic dhclient.conf(5)

#prepend domain-name-servers 127.0.0.1;
request subnet-mask, broadcast-address, time-offset, routers,
	domain-name, domain-name-servers, domain-search, host-name,
	netbios-name-servers, netbios-scope, interface-mtu,
	ntp-servers;
require subnet-mask, domain-name-servers;
#timeout 60;
#retry 60;
#reboot 10;
#select-timeout 5;
#initial-interval 2;

# End /etc/dhcp/dhclient.conf
EOF

# Create the /var/lib/dhclient directory which will contain DHCP 
# Client leases by running the following command:
install -v -dm 755 $BUILDDIR/var/lib/dhclient

# Install the /lib/services/dhclient script included in
# blfs-bootscripts-20140919 package:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-service-dhclient
popd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: The ISC DHCP client
 .
 Kernel configuration:
 You must have Packet Socket support (Networking Support ⇒ Networking Options
 ⇒ Packet Socket) compiled into the kernel. If you do not have IPv6 support
 (Networking Support ⇒ Networking Options ⇒ The IPv6 Protocol) compiled in,
 then you must use the missing_ipv6 patch.
 .
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
        [ -f /etc/sysconfig/ifconfig.eth0 ] && \
		mv -v /etc/sysconfig/{,NOUSE.}ifconfig.eth0

cat > /etc/sysconfig/ifconfig.eth0 << "EOF"
ONBOOT=yes
IFACE=eth0
SERVICE=dhclient
DHCP_START=""
DHCP_STOP=""
PRINTIP=yes
PRINTALL=no
EOF
'

POSTRM_CONF_DEF='
        [ -f /etc/sysconfig/NOUSE.ifconfig.eth0 ] && \
		mv -v /etc/sysconfig/{NOUSE.,}ifconfig.eth0
	'
}

build
