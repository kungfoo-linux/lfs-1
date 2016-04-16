#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=avahi-0.6.31.tar.gz
srcdir=avahi-0.6.31
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i 's/\(CFLAGS=.*\)-Werror \(.*\)/\1\2/' configure
sed -i -e 's/-DG_DISABLE_DEPRECATED=1//' \
	-e '/-DGDK_DISABLE_DEPRECATED/d' avahi-ui/Makefile.in

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     \
            --disable-mono       \
            --disable-monodoc    \
	    --disable-python     \
            --disable-qt3        \
            --enable-core-docs   \
            --with-distro=none   \
            --with-systemdsystemunitdir=no
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

configure() {
# To automatically start the avahi-daemon when the system is rebooted:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-avahi
popd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0), gobject-introspection (>= 1.40.0), \
GTK+2 (>= 2.24.24), GTK+3 (>= 3.12.2), libdaemon (>= 0.14), \
libglade (>= 2.6.4), Qt4 (>= 4.8.6)
Description: a system which facilitates service discovery on a local network
 .
 [avahi-autoipd]
 is a IPv4LL network address configuration daemon.
 .
 [avahi-bookmarks]
 is a Web service showing mDNS/DNS-SD announced HTTP services using the Avahi
 daemon.
 .
 [avahi-browse]
 browses for mDNS/DNS-SD services using the Avahi daemon.
 .
 [avahi-browse-domains]
 browses for mDNS/DNS-SD services using the Avahi daemon.
 .
 [avahi-daemon]
 is the Avahi mDNS/DNS-SD daemon.
 .
 [avahi-discover]
 browses for mDNS/DNS-SD services using the Avahi daemon.
 .
 [avahi-discover-standalone]
 browses for mDNS/DNS-SD services using the Avahi daemon.
 .
 [avahi-dnsconfd]
 is a Unicast DNS server from mDNS/DNS-SD configuration daemon.
 .
 [avahi-publish]
 registers a mDNS/DNS-SD service or host name or address mapping using the
 Avahi daemon.
 .
 [avahi-publish-address]
 registers a mDNS/DNS-SD service or host name or address mapping using the
 Avahi daemon.
 .
 [avahi-publish-service]
 registers a mDNS/DNS-SD service or host name or address mapping using the
 Avahi daemon.
 .
 [avahi-resolve]
 resolves one or more mDNS/DNS host name(s) to IP address(es) (and vice versa)
 using the Avahi daemon.
 .
 [avahi-resolve-address]
 resolves one or more mDNS/DNS host name(s) to IP address(es) (and vice versa)
 using the Avahi daemon.
 .
 [avahi-resolve-host-name]
 resolves one or more mDNS/DNS host name(s) to IP address(es) (and vice versa)
 using the Avahi daemon.
 .
 [avahi-set-host-name]
 changes the mDNS host name.
 .
 [bssh]
 browses for SSH servers on the local network.
 .
 [bvnc]
 browses for VNC servers on the local network.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	if ! getent group "avahi" > /dev/null 2>&1 ; then
	    groupadd -fg 84 avahi
	fi

	if ! getent passwd "avahi" > /dev/null 2>&1 ; then
	    useradd -c "Avahi Daemon Owner" -d /var/run/avahi-daemon -u 84 \
	        -g avahi -s /bin/false avahi
	fi

	if ! getent group "netdev" > /dev/null 2>&1 ; then
	    groupadd -fg 86 netdev
	fi'

POSTRM_CONF_DEF='
	if getent passwd "avahi" > /dev/null 2>&1 ; then
	    userdel avahi
	fi

	if getent group "avahi" > /dev/null 2>&1 ; then
	    groupdel avahi
	fi

	if getent group "netdev" > /dev/null 2>&1 ; then
	    groupdel netdev
	fi'
}

build
