#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=rsync-3.1.1.tar.gz
srcdir=rsync-3.1.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--without-included-zlib
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

configure() {
# For client access to remote files, you may need to install the
# OpenSSH-6.6p1 package to connect to the remote server.
# This is a simple download-only configuration to set up running rsync as a
# server. See the rsyncd.conf(5) man-page for additional options (i.e., user
# authentication). 

mkdir -pv $BUILDDIR/etc
cat > $BUILDDIR/etc/rsyncd.conf << "EOF"
# This is a basic rsync configuration file
# It exports a single module without user authentication.

motd file = /home/rsync/welcome.msg
use chroot = yes

[localhost]
    path = /home/rsync
    comment = Default rsync module
    read only = yes
    list = yes
    uid = rsyncd
    gid = rsyncd
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: popt (>= 1.16), OpenSSH (>= 6.6p1)
Description: fast, versatile, remote (and local) file-copying tool
 rsync is a fast and versatile file-copying tool which can copy locally and
 to/from a remote host. It offers many options to control its behaviour, and
 its remote-update protocol can minimize network traffic to make transferring
 updates between machines fast and efficient.
 .
 It is widely used for backups and mirroring and as an improved copy command
 for everyday use.
 .
 Run rsync server manually:
     rsync --daemon
 .
 To start the rsync server at system boot, install the /etc/rc.d/init.d/rsyncd
 init script included in the blfs-bootscripts-20140919 package (note that you
 only want to start the rsync server if you want to provide an rsync archive
 on your local machine. You don't need this script to run the rsync client):
     make install-rsyncd
 .
 [rsync]
 is a replacement for rcp (and scp) that has many more features. It uses the
 “rsync algorithm” which provides a very fast method of syncing remote files.
 It does this by sending just the differences in the files across the link,
 without requiring that both sets of files are present at one end of the link
 beforehand.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	if ! getent group "rsyncd" > /dev/null 2>&1 ; then
	    groupadd -g 48 rsyncd
	fi

	if ! getent passwd "rsyncd" > /dev/null 2>&1 ; then
	    useradd -c "rsyncd Daemon" -d /home/rsync -g rsyncd \
	        -s /bin/false -u 48 rsyncd
	fi
	'

POSTRM_CONF_DEF='
	if getent passwd "rsyncd" > /dev/null 2>&1 ; then
	    userdel rsyncd
	fi

	if getent group "rsyncd" > /dev/null 2>&1 ; then
	    groupdel rsyncd
	fi
	'
}

build
