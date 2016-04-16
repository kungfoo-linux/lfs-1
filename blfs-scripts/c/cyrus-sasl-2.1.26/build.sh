#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=cyrus-sasl-2.1.26.tar.gz
srcdir=cyrus-sasl-2.1.26
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/cyrus-sasl-2.1.26-fixes-3.patch
autoreconf -fi

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--enable-auth-sasldb \
	--with-dbpath=/var/lib/sasl/sasldb2 \
	--with-saslauthd=/var/run/saslauthd
make
make DESTDIR=$BUILDDIR install
install -v -dm700 $BUILDDIR/var/lib/sasl

cleanup_src .. $srcdir
}

configure() {
# To automatically start saslauthd daemon when the system is rebooted:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-saslauthd
popd

# You'll need to modify /etc/sysconfig/saslauthd and replace the AUTHMECH
# parameter with your desired authentication mechanism:
sed -i -e 's/^START="no"/START="yes"/' \
	-e 's/^AUTHMECH=""/AUTHMECH="sasldb"/' \
	$BUILDDIR/etc/sysconfig/saslauthd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenSSL (>= 1.0.1i)
Recommends: BerkeleyDB (>= 6.1.19)
Suggests: Linux-PAM (>= 1.1.8)
Description: Simple Authentication and Security Layer
 The Cyrus SASL package contains a Simple Authentication and Security Layer, a
 method for adding authentication support to connection-based protocols. To
 use SASL, a protocol includes a command for identifying and authenticating a
 user to a server and for optionally negotiating protection of subsequent
 protocol interactions. If its use is negotiated, a security layer is inserted
 between the protocol and the connection.
EOF
}

build
