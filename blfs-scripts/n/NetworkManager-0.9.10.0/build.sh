#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=NetworkManager-0.9.10.0.tar.xz
srcdir=NetworkManager-0.9.10.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--with-nmtui \
	--disable-ppp \
	--with-systemdsystemunitdir=no
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

configure() {
cat >> $BUILDDIR/etc/NetworkManager/NetworkManager.conf << "EOF"
[main]
plugins=keyfile
EOF

# To automatically start NetworkManager when the system is rebooted:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-networkmanager
popd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: dbus-glib (>= 0.102), libndp (>= 1.4), libnl (>= 3.2.25), \
NSS (>= 3.17), GnuTLS (>= 3.3.7), eudev (>= 1.10)
Recommends: ConsoleKit (>= 0.4.6), dhcpcd (>= 6.4.3), \
gobject-introspection (>= 1.40.0), Iptables (>= 1.4.21), \
libsoup (>= 2.46.0), newt (>= 0.52.17), Polkit (>= 0.112), \
UPower (>= 0.9.23), Vala (>= 0.24.0), Qt4 (>= 4.8.6)
Description: Network connection manager and user applications
 NetworkManager is a set of co-operative tools that make networking simple and
 straightforward. Whether WiFi, wired, 3G, or Bluetooth, NetworkManager allows
 you to quickly move from one network to another: Once a network has been
 configured and joined once, it can be detected and re-joined automatically
 the next time it's available.
EOF
}

build
