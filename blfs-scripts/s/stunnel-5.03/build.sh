#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=stunnel-5.03.tar.gz
srcdir=stunnel-5.03
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var
make
make DESTDIR=$BUILDDIR docdir=/usr/share/doc/stunnel-5.03 install

cat > answer.txt << "EOF"
PL
Mazovia Province
Warsaw
Stunnel Developers
Provisional CA
localhost
EOF
make DESTDIR=$BUILDDIR cert < answer.txt

cleanup_src .. $srcdir
}

configure() {
uid=51
gid=51
install -v -m750 -o $uid -g $gid -d $BUILDDIR/var/lib/stunnel/run
chown $uid:$gid $BUILDDIR/var/lib/stunnel

cat > $BUILDDIR/etc/stunnel/stunnel.conf << "EOF"
; File: /etc/stunnel/stunnel.conf

; Note: The pid and output locations are relative to the chroot location.

pid    = /run/stunnel.pid
chroot = /var/lib/stunnel
client = no
setuid = stunnel
setgid = stunnel
cert   = /etc/stunnel/stunnel.pem

;debug = 7
;output = stunnel.log

;[https]
;accept  = 443
;connect = 80
;; "TIMEOUTclose = 0" is a workaround for a design flaw in Microsoft SSL
;; Microsoft implementations do not use SSL close-notify alert and thus
;; they are vulnerable to truncation attacks
;TIMEOUTclose = 0

EOF
chmod -v 644 $BUILDDIR/etc/stunnel/stunnel.conf
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenSSL (>= 1.0.1i)
Description: an SSL-encrypting socket wrapper
 The stunnel package contains a program that allows you to encrypt arbitrary
 TCP connections inside SSL (Secure Sockets Layer) so you can easily
 communicate with clients over secure channels. stunnel can be used to add SSL
 functionality to commonly used Inetd daemons like POP-2, POP-3, and IMAP
 servers, to standalone daemons like NNTP, SMTP and HTTP, and in tunneling PPP
 over network sockets without changes to the server package source code.
 .
 [stunnel] is a program designed to work as an SSL encryption wrapper between
 remote clients and local ({x}inetd-startable) or remote servers.
 .
 [stunnel3] is a Perl wrapper script to use stunnel 3.x syntax with
 stunnel >=4.05.
 .
 [libstunnel.so] contains the API functions required by stunnel. 
 .
 you need to add the service(s) you wish to encrypt to the configuration file.
 The format is as follows:
 ---------------------------------
 [<service>]
 accept  = <hostname:portnumber>
 connect = <hostname:portnumber>
 ---------------------------------
 .
 To automatically start the stunnel daemon when the system is rebooted,
 install the /etc/rc.d/init.d/stunnel bootscript from the
 blfs-bootscripts-20140919 package:
 $ make install-stunnel
EOF
}

set_deb_def() {
POSTINST_CONF_DEF="
	if ! getent group \"stunnel\" > /dev/null 2>&1 ; then
	    groupadd -g 51 stunnel
	fi

	if ! getent passwd \"stunnel\" > /dev/null 2>&1 ; then
	    useradd -c \"stunnel Daemon\" -d /var/lib/stunnel \
		-g stunnel -s /bin/false -u 51 stunnel
	fi
	"
POSTRM_CONF_DEF="
	if getent passwd \"stunnel\" > /dev/null 2>&1 ; then
	    userdel stunnel
	fi

	if getent group \"stunnel\" > /dev/null 2>&1 ; then
	    groupdel stunnel
	fi
	"
}

build
