#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=colord-1.2.3.tar.xz
srcdir=colord-1.2.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr         \
	--sysconfdir=/etc         \
	--localstatedir=/var      \
	--with-daemon-user=colord \
	--enable-vala             \
	--enable-systemd-login=no \
	--disable-bash-completion \
	--disable-static          \
	--with-systemdsystemunitdir=no
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: DBus (>= 1.8.8), GLib (>= 2.40.0), lcms2 (>= 2.6), SQLite (>= 3.8.6), \
libgusb (>= 0.1.6), gobject-introspection (>= 1.40.0), Polkit (>= 0.112), \
Eudev (>= 1.10), Vala (>= 0.24.0)
Description: system service to manage device colour profiles
 colord is a system service that makes it easy to manage, install and generate
 colour profiles to accurately colour manage input and output devices.
 .
 It provides a D-Bus API for system frameworks to query, a persistent data
 store, and a mechanism for session applications to set system policy.
 .
 [cd-create-profile]
 is a Color Manager Profile Creation Tool.
 .
 [cd-fix-profile]
 is a tool used to fix metadata in ICC profiles.
 .
 [colormgr]
 is a text-mode program that allows you to interact with colord on the command
 line.
 .
 [libcolord.so]
 contains the Colord API functions.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	if ! getent group "colord" > /dev/null 2>&1 ; then
	    groupadd -g 71 colord
	fi

	if ! getent passwd "colord" > /dev/null 2>&1 ; then
            useradd -c "Color Daemon Owner" -d /var/lib/colord -u 71 \
	        -g colord -s /bin/false colord
	fi'

POSTRM_CONF_DEF='
	if getent passwd "colord" > /dev/null 2>&1 ; then
	    userdel colord
	fi

	if getent group "colord" > /dev/null 2>&1 ; then
	    groupdel colord
	fi'
}

build
