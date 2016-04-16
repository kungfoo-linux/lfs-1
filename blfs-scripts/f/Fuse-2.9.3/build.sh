#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=fuse-2.9.3.tar.gz
srcdir=fuse-2.9.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	INIT_D_PATH=/tmp/init.d
make
make DESTDIR=$BUILDDIR install

mkdir -pv $BUILDDIR/lib
mv -v $BUILDDIR/usr/lib/libfuse.so.* $BUILDDIR/lib
ln -sfv ../../lib/libfuse.so.2.9.3 $BUILDDIR/usr/lib/libfuse.so
rm -rf  $BUILDDIR/tmp
install -v -m755 -d $BUILDDIR/usr/share/doc/fuse-2.9.3
install -v -m644 doc/{how-fuse-works,kernel.txt} \
	$BUILDDIR/usr/share/doc/fuse-2.9.3

cleanup_src .. $srcdir
}

configure() {
# Some options regarding mount policy can be set in the file /etc/fuse.conf
# (Additional information about the meaning of the configuration options are
# found in the man page):

cat > $BUILDDIR/etc/fuse.conf << "EOF"
# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#
#mount_max = 1000

# Allow non-root users to specify the 'allow_other' or 'allow_root'
# mount options.
#
#user_allow_other
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: User space File System
 FUSE (Filesystem in Userspace) is a simple interface for userspace programs
 to export a virtual filesystem to the Linux kernel. Fuse also aims to provide
 a secure method for non privileged users to create and mount their own
 filesystem implementations.
 .
 Kernel configuration:
 --------------------------------------------------
 . File systems  --->
 .   <*> FUSE (Filesystem in Userspace) support
 .       <*> Character device in Userspace support
 --------------------------------------------------
 .
 [fusermount]
 is a set users ID root program to mount and unmount Fuse filesystems.
 .
 [mount.fuse]
 is the command mount would call to mount a Fuse filesystem.
 .
 [ulockmgr_server]
 is the Userspace Lock Manager Server for Fuse filesystems.
 .
 [libfuse.so]
 contains the FUSE API functions.
 .
 [libulockmgr.so]
 contains the Userspace Lock Manager API functions.
EOF
}

build
