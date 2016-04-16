#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=rpcbind-0.2.1.tar.bz2
srcdir=rpcbind-0.2.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i "/servname/s:rpcbind:sunrpc:" src/rpcbind.c
sed -i "/error = getaddrinfo/s:rpcbind:sunrpc:" src/rpcinfo.c

./configure --prefix=/usr \
	--bindir=/sbin \
	--with-rpcuser=root
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

configure() {
# Install the /etc/rc.d/init.d/rpcbind init script:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-rpcbind
popd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libtirpc (>= 0.2.5)
Replaces: portmap (>= 6.0)
Description: converts RPC program numbers into universal addresses
 The rpcbind program is a replacement for portmap. It is required for import
 or export of Network File System (NFS) shared directories.
EOF
}

build
