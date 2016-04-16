#!/bin/bash -e
. ../../blfs.comm

build_src() {
# Creating Directories
mkdir -pv $BUILDDIR/{dev,proc,sys,run}
mkdir -pv $BUILDDIR/{bin,boot,etc/{opt,sysconfig},home,lib,mnt,opt}
mkdir -pv $BUILDDIR/{media/{floppy,cdrom},sbin,srv,var}
mkdir -pv $BUILDDIR/usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv $BUILDDIR/usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv $BUILDDIR/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv $BUILDDIR/usr/libexec
mkdir -pv $BUILDDIR/usr/{,local/}share/man/man{1..8}
mkdir -pv $BUILDDIR/mnt/{lfs,usb,data}
mkdir -pv $BUILDDIR/var/{log,mail,spool}
mkdir -pv $BUILDDIR/var/{opt,cache,lib/{color,misc,locate},local}
install -dv -m 0750 $BUILDDIR/root
install -dv -m 1777 $BUILDDIR/{tmp,var/tmp}

ln -sv /run $BUILDDIR/var/run
ln -sv /run/lock $BUILDDIR/var/lock

case $(uname -m) in
    x86_64) ln -sv lib $BUILDDIR/lib64
        ln -sv lib $BUILDDIR/usr/lib64
	ln -sv lib $BUILDDIR/usr/local/lib64 ;;
esac

touch $BUILDDIR/var/log/{btmp,lastlog,wtmp}
chgrp -v utmp $BUILDDIR/var/log/lastlog
chmod -v 664  $BUILDDIR/var/log/lastlog
chmod -v 600  $BUILDDIR/var/log/btmp
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Priority: required
Essential: yes
Description: Linux From Scratch
EOF
}

build
