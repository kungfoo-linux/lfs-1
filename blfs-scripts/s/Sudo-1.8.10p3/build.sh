#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=sudo-1.8.10p3.tar.gz
srcdir=sudo-1.8.10p3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--libexecdir=/usr/lib \
	--with-all-insults \
	--with-env-editor \
	--docdir=/usr/share/doc/sudo-1.8.10p3 \
	--with-passprompt="[sudo] password for %p: " \
	--without-pam \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Provide limited super user privileges to specific users
 The Sudo package allows a system administrator to give certain users (or
 groups of users) the ability to run some (or all) commands as root or another
 user while logging the commands and arguments.
 .
 [sudo]
 executes a command as another user as permitted by the /etc/sudoers
 configuration file.
 .
 [sudoedit]
 is a symlink to sudo that implies the -e option to invoke an editor as
 another user.
 .
 [visudo]
 allows for safer editing of the sudoers file.
 .
 [sudoreplay]
 is used to play back or list the output logs created by sudo. 
EOF
}

build
