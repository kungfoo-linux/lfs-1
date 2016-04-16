#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=ConsoleKit-0.4.6.tar.xz
srcdir=ConsoleKit-0.4.6
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr    \
	--sysconfdir=/etc    \
	--localstatedir=/var \
	--enable-udev-acl    \
	--enable-pam-module  \
	--with-systemdsystemunitdir=no
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

configure() {
mkdir -pv $BUILDDIR/usr/lib/ConsoleKit/run-session.d
cat > $BUILDDIR/usr/lib/ConsoleKit/run-session.d/pam-foreground-compat.ck << "EOF"
#!/bin/sh
TAGDIR=/var/run/console

[ -n "$CK_SESSION_USER_UID" ] || exit 1
[ "$CK_SESSION_IS_LOCAL" = "true" ] || exit 0

TAGFILE="$TAGDIR/`getent passwd $CK_SESSION_USER_UID | cut -f 1 -d:`"

if [ "$1" = "session_added" ]; then
    mkdir -p "$TAGDIR"
    echo "$CK_SESSION_ID" >> "$TAGFILE"
fi

if [ "$1" = "session_removed" ] && [ -e "$TAGFILE" ]; then
    sed -i "\%^$CK_SESSION_ID\$%d" "$TAGFILE"
    [ -s "$TAGFILE" ] || rm -f "$TAGFILE"
fi
EOF
chmod -v 755 $BUILDDIR/usr/lib/ConsoleKit/run-session.d/pam-foreground-compat.ck
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: dbus-glib (>= 0.102), Xorg-lib (>= 7.7),  Linux-PAM (>= 1.1.8), \
Polkit (>= 0.112)
Description: framework for defining and tracking users, sessions and seats
 The ConsoleKit package is a framework for keeping track of the various users,
 sessions, and seats present on a system. It provides a mechanism for software
 to react to changes of any of these items or of any of the metadata
 associated with them.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
    pattern="^# Begin ConsoleKit addition"
    file=/etc/pam.d/system-session
    line="
# Begin ConsoleKit addition
session   optional    pam_loginuid.so
session   optional    pam_ck_connector.so nox11
# End ConsoleKit addition"
    addline_unique "$pattern" "$line" $file'

POSTRM_CONF_DEF='
    pattern_bgn="^#\sBegin\sConsoleKit\saddition"
    pattern_end="#\sEnd\sConsoleKit\saddition"
    pattern_block=${pattern_bgn}"\n.*\n"${pattern_end}
    file=/etc/pam.d/system-session
    delblock $pattern_bgn $pattern_end $pattern_block $file'
}

build
