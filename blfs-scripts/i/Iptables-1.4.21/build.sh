#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=iptables-1.4.21.tar.bz2
srcdir=iptables-1.4.21
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sbindir=/sbin \
	--with-xtlibdir=/lib/xtables \
	--enable-libipq
make
make DESTDIR=$BUILDDIR install

mkdir -pv $BUILDDIR/lib
ln -sfv ../../sbin/xtables-multi $BUILDDIR/usr/bin/iptables-xml
for file in ip4tc ip6tc ipq iptc xtables
do
	mv -v $BUILDDIR/usr/lib/lib${file}.so.* $BUILDDIR/lib
	ln -sfv ../../lib/$(readlink $BUILDDIR/usr/lib/lib${file}.so) \
		$BUILDDIR/usr/lib/lib${file}.so
done

cleanup_src .. $srcdir
}

configure() {
install -dv -m 755 $BUILDDIR/etc/rc.d/{init.d,rc{3,4,5}.d}
install -m 754 $BLFSSRC/b/bootscripts/blfs/init.d/iptables \
	$BUILDDIR/etc/rc.d/init.d/
ln -sf  ../init.d/iptables $BUILDDIR/etc/rc.d/rc3.d/S19iptables
ln -sf  ../init.d/iptables $BUILDDIR/etc/rc.d/rc4.d/S19iptables
ln -sf  ../init.d/iptables $BUILDDIR/etc/rc.d/rc5.d/S19iptables

install -m 700 rc.iptables $BUILDDIR/etc/rc.d/
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: tools for managing Linux kernel packet filtering capabilities
 The next part of this chapter deals with firewalls. The principal firewall
 tool for Linux is Iptables. You will need to install Iptables if you intend
 on using any form of a firewall.
 .
 [iptables] 
 is used to set up, maintain, and inspect the tables of IP packet filter rules
 in the Linux kernel.
 .
 [iptables-restore] 
 is used to restore IP Tables from data specified on STDIN. Use I/O
 redirection provided by your shell to read from a file.
 .
 [iptables-save]
 is used to dump the contents of an IP Table in easily parseable format to
 STDOUT. Use I/O-redirection provided by your shell to write to a file.
 .
 [iptables-xml]
 is used to convert the output of iptables-save to an XML format. Using the
 iptables.xslt stylesheet converts the XML back to the format of
 iptables-restore.
 .
 [ip6tables*]
 are a set of commands for IPV6 that parallel the iptables commands above.
 .
 [nfsynproxy]
 (optional) configuration tool. SYNPROXY target makes handling of large SYN
 floods possible without the large performance penalties imposed by the
 connection tracking in such cases. 
EOF
}

build
