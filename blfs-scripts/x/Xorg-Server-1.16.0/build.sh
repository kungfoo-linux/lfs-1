#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xorg-server-1.16.0.tar.bz2
srcdir=xorg-server-1.16.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# If you are enabling glamor, apply the recommended patch by running the
# following command:
patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/xorg-server-1.16.0-upstream_glamor_fix-1.patch

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/xorg-server-1.16.0-add_prime_support-1.patch
sed -i "/scrnintstr/i #include <xorg-server.h>" exa/exa.h glamor/glamor.h

./configure $XORG_CONFIG               \
	--with-xkb-output=/var/lib/xkb \
	--enable-dmx                   \
	--enable-glamor                \
	--enable-install-setuid        \
	--enable-suid-wrapper
make
make DESTDIR=$BUILDDIR install

mkdir -pv $BUILDDIR/etc/{sysconfig,X11/xorg.conf.d}
cat > $BUILDDIR/etc/sysconfig/createfiles << "EOF"
/tmp/.ICE-unix dir 1777 root root
/tmp/.X11-unix dir 1777 root root
EOF

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenSSL (>= 1.0.1i), Pixman (>= 0.32.6), Xorg-font (= 7.7), \
xkeyboard-config (>= 2.12), libepoxy (>= 1.2), acpid (>= 2.0.23)
Description: the core of the X Window system
 .
 [cvt]
 calculates VESA CVT mode lines.
 .
 [dmx*]
 are various tools used for manipulating the dmx server.
 .
 [gtf]
 calculates VESA GTF mode lines.
 .
 [vdltodmx]
 is a tool used to convert VDL config files to DMX config files.
 .
 [X]
 is a symbolic link to Xorg.
 .
 [Xnest]
 is a nested X server.
 .
 [Xorg]
 is the X11R7 X Server.
 .
 [Xvfb]
 is the virtual framebuffer X server for X Version 11.
 .
 [xdmxconfig]
 is a graphical configuration utility for the dmx server.
EOF
}

build
