#!/bin/bash -e
. ../../blfs.comm

add_user() {
if ! getent group "nogroup" > /dev/null 2>&1 ; then
	groupadd -g 99 nogroup
fi

if ! getent passwd "nobody" > /dev/null 2>&1 ; then
	useradd -c "Unprivileged Nobody" -d /dev/null -g nogroup \
		-s /bin/false -u 99 nobody
fi
}

build_src() {
srcfil=nfs-utils-1.3.0.tar.bz2
srcdir=nfs-utils-1.3.0

tar -xf $BLFSSRC/$PKGLETTER/NFS-Utils-1.3.0/$srcfil
cd $srcdir

add_user

patch -Np1 -i $BLFSSRC/$PKGLETTER/NFS-Utils-1.3.0/nfs-utils-1.3.0-gcc_4_9-1.patch
./configure --prefix=/usr \
	--sysconfdir=/etc \
	--without-tcp-wrappers \
	--disable-nfsv4 \
	--disable-gss
make $JOBS
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

configure() {
# Install the /etc/rc.d/init.d/nfs-client init script:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-nfs-client
popd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: rpcbind (>= 0.2.1)
Conflicts: nfs-utils-server (>= 1.3.0)
Description: NFS client tools
 The NFS Utilities package contains the userspace server and client tools
 necessary to use the kernel's NFS abilities. NFS is a protocol that allows
 sharing file systems over the network.
 .
 Kernel configuration:
 --------------------------------------------------
 . File systems  --->
 .       Network File Systems  --->
 .           NFS client support: Y or M
 --------------------------------------------------
EOF
}

build
