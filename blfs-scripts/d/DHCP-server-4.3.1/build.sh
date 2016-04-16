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

# Install the ISC DHCP server only:
make DESTDIR=$BUILDDIR -C server install

cleanup_src .. $srcdir
}

configure() {
cat > $BUILDDIR/etc/dhcp/dhcpd.conf << "EOF"
# Begin /etc/dhcp/dhcpd.conf
#
# Example dhcpd.conf(5)

# Use this to enble / disable dynamic dns updates globally.
ddns-update-style none;

# option definitions common to all supported networks...
#option domain-name "example.org";
#option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 600;
max-lease-time 7200;

# This is a very basic subnet declaration.
subnet 192.168.1.0 netmask 255.255.255.0 {
  range 192.168.1.100 192.168.1.200;
  #option routers rtr-239-0-1.example.org, rtr-239-0-2.example.org;
}

# End /etc/dhcp/dhcpd.conf
EOF

# create the /var/lib/dhcpd directory which will contain DHCP Server 
# leases by running the following command:
install -v -dm 755 $BUILDDIR/var/lib/dhcpd
touch $BUILDDIR/var/lib/dhcpd/dhcpd.leases

# You will need to edit the /etc/sysconfig/dhcpd in order to set 
# the interface on which dhcpd will serve the DHCP requests (for example,
# eth0):
sed -i 's/^INTERFACES=\"\"/INTERFACES=\"eth0\"/' \
	$BUILDDIR/etc/sysconfig/dhcpd

# start the DHCP Server at boot, install the /etc/rc.d/init.d/dhcpd init
# script included in the blfs-bootscripts-20140919 package:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-dhcpd
popd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: The ISC DHCP server
 .
 Kernel configuration:
 You must have Packet Socket support (Networking Support ⇒ Networking Options
 ⇒ Packet Socket) compiled into the kernel. If you do not have IPv6 support
 (Networking Support ⇒ Networking Options ⇒ The IPv6 Protocol) compiled in,
 then you must use the missing_ipv6 patch.
 .
EOF
}

build
