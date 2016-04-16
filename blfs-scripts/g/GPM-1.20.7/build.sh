#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gpm-1.20.7.tar.bz2
srcdir=gpm-1.20.7
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./autogen.sh

./configure --prefix=/usr \
	--sysconfdir=/etc
make
make DESTDIR=$BUILDDIR install

ln -sfv libgpm.so.2.1.0 $BUILDDIR/usr/lib/libgpm.so
install -v -m644 conf/gpm-root.conf $BUILDDIR/etc
install-info --dir-file=/tmp/dir $BUILDDIR/usr/share/info/gpm.info

cleanup_src .. $srcdir
}

configure() {
# /etc/sysconfig/mouse contains the name of your mouse device and the
# protocol it uses.
# A list of which protocol values are known can be found by running:
#   gpm -m [device] -t -help

mkdir -pv $BUILDDIR/etc/sysconfig
cat > $BUILDDIR/etc/sysconfig/mouse << "EOF"
# Begin /etc/sysconfig/mouse

MDEVICE="/dev/input/mouse0"
PROTOCOL="imps2"
GPMOPTS=""

# End /etc/sysconfig/mouse
EOF

# Install the /etc/rc.d/init.d/gpm init script included in the
# blfs-bootscripts-20140919 package:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-gpm
popd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: General Purpose Mouse daemon
 The GPM (General Purpose Mouse daemon) package contains a mouse server for
 the console and xterm. It not only provides cut and paste support generally,
 but its library component is used by various software such as Links to
 provide mouse support to the application. It is useful on desktops,
 especially if following (Beyond) Linux From Scratch instructions; it's often
 much easier (and less error prone) to cut and paste between two console
 windows than to type everything by hand!
EOF
}

build
