#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=sysstat-11.1.1.tar.xz
srcdir=sysstat-11.1.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sa_lib_dir=/usr/lib/sa \
sa_dir=/var/log/sa \
conf_dir=/etc/sysconfig \
./configure --prefix=/usr \
	--disable-man-group
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

configure() {
# At system startup, a LINUX RESTART message must be inserted in the daily
# data file to reinitialize the kernel counters. This can be automated by
# installing the /etc/rc.d/init.d/sysstat init script included in the
# blfs-bootscripts-20140919 package:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-sysstat
popd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Fcron (>= 3.2.0)
Description: Collection of performance monitoring tools for Linux
 The Sysstat package contains utilities to monitor system performance and
 usage activity. Sysstat contains the sar utility, common to many commercial
 Unixes, and tools you can schedule via cron to collect and historize
 performance and activity data.
 .
 Below is an example of what to install in the crontab. Adjust the parameters
 to suit your needs. Use man sa1 and man sa2 for information about the
 commands:
 # 8am-7pm activity reports every 10 minutes during weekdays
 0 8-18 * * 1-5 /usr/lib/sa/sa1 600 6 &
 .
 # 7pm-8am activity reports every hour during weekdays
 0 19-7 * * 1-5 /usr/lib/sa/sa1 &
 .
 # Activity reports every hour on Saturday and Sunday
 0 * * * 0,6 /usr/lib/sa/sa1 &
 .
 # Daily summary prepared at 19:05
 5 19 * * * /usr/lib/sa/sa2 -A &
EOF
}

build
