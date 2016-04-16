#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=sshfs-fuse-2.5.tar.gz
srcdir=sshfs-fuse-2.5
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
Depends: Fuse (>= 2.9.3), GLib (>= 2.40.0), OpenSSH (>= 6.6p1)
Description: filesystem running over SFTP
 The Sshfs Fuse package contains a filesystem client based on the SSH File
 Transfer Protocol. This is useful for mounting a remote computer that you
 have ssh access to as a local filesystem. This allows you to drag and drop
 files or run shell commands on the remote files as if they were on your local
 computer.
 .
 [sshfs]
 mounts an ssh server as a local file system.
EOF
}

build
