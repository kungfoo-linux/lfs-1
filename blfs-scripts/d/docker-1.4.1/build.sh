#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=abc-x.y.z.tar.bz2
srcdir=abc-x.y.z
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
Depends: xxx
Recommends:
Suggests:
Description: xxx
EOF
}

build



# kernel: AUFS
# kernel command line: cgroup_enable=memory swapaccount=1

groupadd 
