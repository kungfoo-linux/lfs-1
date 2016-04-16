#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=mpssh-1.3.3.tar.bz2
srcdir=mpssh-1.3.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Mass Parallel SSH
 mpssh is a tool to execute commands on many machines via SSH, and get a
 nicely formatted output.
EOF
}

build

#	strip --strip-all mpssh
#	cp mpssh /usr/sbin
#	mkdir -pv ~/.mpssh
#	cp hosts.sample ~/.mpssh/hosts
