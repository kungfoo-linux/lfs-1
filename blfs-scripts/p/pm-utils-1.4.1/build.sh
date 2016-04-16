#!/bin/bash -e
. ../../blfs.comm

build_src() {
# need xmlto-0.0.26 to generate man pages

srcfil=pm-utils-1.4.1.tar.gz
srcdir=pm-utils-1.4.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--docdir=/usr/share/doc/pm-utils-1.4.1
make
make DESTDIR=$BUILDDIR install

mkdir -pv $BUILDDIR/usr/share/man/man{1,8}
install -v -m644 man/*.1 $BUILDDIR/usr/share/man/man1
install -v -m644 man/*.8 $BUILDDIR/usr/share/man/man8

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: utilities and scripts for power management
 .
 [on_ac_power]
 is a script that determines whether the system is running on AC power (rather
 than a battery).
 .
 [pm-hibernate]
 is a symlink to pm-action script that puts the computer into hibernate mode
 (the system is fully powered off and system state is saved to disk).
 .
 [pm-is-supported]
 is a script that checks whether power management features such as suspend and
 hibernate are supported.
 .
 [pm-powersave]
 is a script that puts the computer into powersaving (low power) mode.
 .
 [pm-suspend]
 is a symlink to pm-action script that puts the computer into suspend mode
 (most devices are shut down and system state is saved in RAM).
 .
 [pm-suspend-hybrid]
 is a symlink to pm-action script that puts the computer into hybrid-suspend
 mode (the system does everything it needs to hibernate, but suspends instead
 of shutting down).
EOF
}

build
