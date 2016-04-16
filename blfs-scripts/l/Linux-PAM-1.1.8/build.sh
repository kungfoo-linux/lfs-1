#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=Linux-PAM-1.1.8.tar.bz2
srcdir=Linux-PAM-1.1.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/Linux-PAM-1.1.8-docs.tar.bz2 \
	--strip-components=1

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--libdir=/usr/lib \
	--enable-securedir=/lib/security \
	--docdir=/usr/share/doc/Linux-PAM-1.1.8
make
make DESTDIR=$BUILDDIR install

chmod -v 4755 $BUILDDIR/sbin/unix_chkpwd &&
for file in pam pam_misc pamc
do
	mv -v $BUILDDIR/usr/lib/lib${file}.so.* $BUILDDIR/lib &&
	ln -sfv ../../lib/$(readlink $BUILDDIR/usr/lib/lib${file}.so) \
		$BUILDDIR/usr/lib/lib${file}.so
done

cleanup_src .. $srcdir
}

configure() {
# Configuration information is placed in /etc/pam.d/. 
# Below is an example file:

mkdir -pv $BUILDDIR/etc/pam.d
cat > $BUILDDIR/etc/pam.d/other << "EOF"
# Begin /etc/pam.d/other

auth            required        pam_unix.so     nullok
account         required        pam_unix.so
session         required        pam_unix.so
password        required        pam_unix.so     nullok

# End /etc/pam.d/other
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: CrackLib (>= 2.9.1), libtirpc (>= 0.2.5)
Suggests: Berkeley_DB-6.1.19, Prelude 
Description: Pluggable Authentication Modules library
 The Linux PAM package contains Pluggable Authentication Modules used to 
 enable the local system administrator to choose how applications 
 authenticate users.
 .
 [mkhomedir_helper] is a helper binary that creates home directories.
 .
 [pam_tally] is used to interrogate and manipulate the login counter file.
 .
 [pam_tally2] is used to interrogate and manipulate the login counter file, 
 but does not have some limitations that pam_tally does.
 .
 [pam_timestamp_check] is used to check if the default timestamp is valid
 .
 [unix_chkpwd] is a helper binary that verifies the password of the current 
 user.
 .
 [unix_update] is a helper binary that updates the password of a given user.
 .
 [libpam.so] provides the interfaces between applications and the PAM modules.
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='
CLR_RED="\E[31m"
CLR_END="\E[0m"
'

POSTINST_CONF_DEF='
	echo -e $CLR_RED \
	"[Important]\n" \
	"You should now reinstall the Shadow-4.2.1 package." \
	$CLR_END
	'
}

build
