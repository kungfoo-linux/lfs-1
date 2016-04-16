#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=polkit-0.112.tar.gz
srcdir=polkit-0.112
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--disable-static \
	--enable-libsystemd-login=no \
	--with-authfw=shadow
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0), JS17 (>= 17.0.0), gobject-introspection (>= 1.40.0)
Description: an authorization framework
 Polkit is a toolkit for defining and handling authorizations. It is used for
 allowing unprivileged processes to communicate with privileged processes.
 .
 [pkaction] is used to obtain information about registered PolicyKit actions.
 .
 [pkcheck] is used to check whether a process is authorized for action.
 .
 [pkexec] allows an authorized user to execute a command as another user.
 .
 [pkttyagent] is used to start a textual authentication agent for the subject.
 .
 [polkitd] provides the org.freedesktop.PolicyKit1 D-Bus service on the
 system message bus.
 .
 [libpolkit-agent-1.so] contains the Polkit authentication agent API functions.
 .
 [libpolkit-gobject-1.so] contains the Polkit authorization API functions. 
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	if ! getent group "polkitd" > /dev/null 2>&1 ; then
	    groupadd -fg 27 polkitd
	fi

	if ! getent passwd "polkitd" > /dev/null 2>&1 ; then
	    useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 \
                -g polkitd -s /bin/false polkitd
	fi
	'

POSTRM_CONF_DEF='
	if getent passwd "polkitd" > /dev/null 2>&1 ; then
	    userdel polkitd
	fi

	if getent group "polkitd" > /dev/null 2>&1 ; then
	    groupdel polkitd
	fi
	'
}

build
