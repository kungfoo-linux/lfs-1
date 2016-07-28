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




############################################################
$ sudo docker daemon &

WARN[0000] containerd: low RLIMIT_NOFILE changing to max  current=1024 max=4096
  ==>
  cat >> /etc/security/limits.conf << "EOF"
  *          soft    nofile     10000
  *          hard    nofile     10000
  root       soft    nofile     10000
  root       hard    nofile     10000
  EOF

WARN[0001] Your kernel does not support swap memory limit. 
  ==>
  modify /etc/default/grub, change:
  GRUB_CMDLINE_LINUX_DEFAULT="cgroup_enable=memory swapaccount=1"
  GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"

  $ update-grub
  $ reboot


WARN[0001] mountpoint for pids not found 
