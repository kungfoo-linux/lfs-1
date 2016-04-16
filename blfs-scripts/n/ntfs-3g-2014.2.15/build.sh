#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=ntfs-3g_ntfsprogs-2014.2.15.tgz
srcdir=ntfs-3g_ntfsprogs-2014.2.15
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

ln -sv ../bin/ntfs-3g $BUILDDIR/sbin/mount.ntfs
ln -sv $BUILDDIR/usr/share/man/man8/{ntfs-3g,mount.ntfs}.8

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: NTFS filesystem driver and utilities
 The Ntfs-3g package contains a stable, read-write open source driver for
 NTFS partitions. NTFS partitions are used by newer Microsoft operating
 systems. Ntfs-3g enables you to mount NTFS partitions in read-write mode
 from your Linux system. It uses the FUSE kernel module to be able to
 implement NTFS support in user space.
 This package contains both the NTFS-3g driver itself and various utilities
 useful for manipulating NTFS partitions.
 .
 Kernel configuration:
 --------------------------------------------------
 . File systems  --->
 .   <*> FUSE (Filesystem in Userspace) support
 .       <*> Character device in Userspace support
 --------------------------------------------------
 .
 [lowntfs-3g]
 is similar to ntfs-3g but uses the Fuse low-level interface.
 .
 [mkfs.ntfs]
 is a symlink to mkntfs.
 .
 [mkntfs]
 creates an NTFS file system.
 .
 [mount.lowntfs-3g]
 is a symlink to lowntfs-3g.
 .
 [mount.ntfs]
 mounts an NTFS filesystem.
 .
 [mount.ntfs-3g]
 is a symbolic link to ntfs-3g.
 .
 [ntfs-3g]
 is an NTFS driver, which can create, remove, rename, move files,
 directories, hard links, and streams; it can read and write files, including
 streams, sparse files and transparently compressed files; it can handle
 special files like symbolic links, devices, and FIFOs; moreover it provides
 standard management of file ownership and permissions, including POSIX ACLs.
 .
 [ntfs-3g.probe]
 tests if an NTFS volume is mountable read only or read-write, and exits with
 a status value accordingly. The volume can be a block device or image file.
 .
 [ntfs-3g.secaudit]
 audits NTFS Security Data.
 .
 [ntfs-3g.usermap]
 creates the file defining the mapping of Windows accounts to Linux logins
 for users who owns files which should be visible from both Windows and Linux.
 .
 [ntfscluster]
 identifies files in a specified region of an NTFS volume
 .
 [ntfscp]
 copies a file to an NTFS volume.
 .
 [ntfsfix]
 fixes common errors and forces Windows to check an NTFS partition.
 .
 [ntfsls]
 lists directory contents on an NTFS filesystem.
 .
 [ntfscat]
 prints NTFS files and streams on the standard output.
 .
 [ntfsclone]
 clones an NTFS filesystem.
 .
 [ntfscmp]
 compares two NTFS filesystems and tells the differences.
 .
 [ntfsinfo]
 dumps a file's attributes.
 .
 [ntfslabel]
 displays or changes the label on an ntfs file system.
 .
 [ntfsresize]
 resizes an NTFS filesystem without data loss.
 .
 [ntfsundelete]
 recovers a deleted file from an NTFS volume.
 .
 [libntfs-3g.so]
 contains the Ntfs-3g API functions. 
EOF
}

build
