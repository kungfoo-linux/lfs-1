#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=haveged-1.9.1.tar.gz
srcdir=haveged-1.9.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

mkdir -pv    $BUILDDIR/usr/share/doc/haveged-1.9.1 &&
cp -v README $BUILDDIR/usr/share/doc/haveged-1.9.1

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Linux entropy source using the HAVEGE algorithm
 The Haveged package contains a daemon that generates an unpredictable stream
 of random numbers and feeds the /dev/random device.
 .
 [haveged] is a daemon that generates an unpredictable stream of random 
 numbers harvested from the indirect effects of hardware events based on 
 hidden processor states (caches, branch predictors, memory translation 
 tables, etc). 
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
        echo -e \
	" If you want the Haveged daemon to start automatically when the\n" \
	"system is booted, install the /etc/rc.d/init.d/haveged init script\n" \
	"included in the blfs-bootscripts-20140919 package:\n" \
	"    make install-haveged\n\n" \
	"or run it manually:\n" \
	"    haveged"
	'
}

build
