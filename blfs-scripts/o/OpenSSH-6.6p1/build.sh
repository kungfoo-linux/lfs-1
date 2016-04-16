#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=openssh-6.6p1.tar.gz
srcdir=openssh-6.6p1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

install -v -m700 -d $BUILDDIR/var/lib/sshd
chown -v root:sys $BUILDDIR/var/lib/sshd

./configure --prefix=/usr \
	--sysconfdir=/etc/ssh \
	--with-md5-passwords \
	--with-privsep-path=/var/lib/sshd
make
make install
make DESTDIR=$BUILDDIR install
cp -n /etc/ssh/* $BUILDDIR/etc/ssh

install -v -m755 contrib/ssh-copy-id $BUILDDIR/usr/bin
install -v -m644 contrib/ssh-copy-id.1 $BUILDDIR/usr/share/man/man1
install -v -m755 -d $BUILDDIR/usr/share/doc/openssh-6.6p1
install -v -m644 INSTALL LICENCE OVERVIEW README* \
	$BUILDDIR/usr/share/doc/openssh-6.6p1

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: openssl (>= 1.0.1i)
Suggests: Linux-PAM-1.1.8, X_Window_System, MIT_Kerberos_V5-1.12.2, \
 libedit, OpenSC, libsectok
Description: secure shell (SSH) server and client
 The OpenSSH package contains ssh clients and the sshd daemon. This is useful
 for encrypting authentication and subsequent traffic over a network. The ssh
 and scp commands are secure implementions of telnet and rcp respectively. 
 .
 To start the SSH server at system boot, install the /etc/rc.d/init.d/sshd 
 init script includeed in the blfs-bootscripts-20140919 package:
     make install-sshd
 .
 If you want run ssh manual, you can execute the command:
     /usr/sbin/sshd
 .
 [scp] is a file copy program that acts like rcp except it uses an 
 encrypted protocol.
 .
 [sftp] is an FTP-like program that works over the SSH1 and SSH2 protocols.
 .
 [sftp-server] is an SFTP server subsystem. This program is not normally 
 called directly by the user.
 .
 [slogin] is a symlink to ssh.
 .
 [ssh] is an rlogin/rsh-like client program except it uses an encrypted 
 protocol.
 .
 [sshd] is a daemon that listens for ssh login requests.
 .
 [ssh-add] is a tool which adds keys to the ssh-agent.
 .
 [ssh-agent] is an authentication agent that can store private keys.
 .
 [ssh-copy-id] is a script that enables logins on remote machine using 
 local keys.
 .
 [ssh-keygen] is a key generation tool.
 .
 [ssh-keyscan] is a utility for gathering public host keys from a number 
 of hosts.
 .
 [ssh-keysign] is used by ssh to access the local host keys and generate 
 the digital signature required during hostbased authentication with SSH 
 protocol version 2.
 This program is not normally called directly by the user.
 .
 [ssh-pkcs11-helper] is a ssh-agent helper program for PKCS#11 support. 
EOF
}

set_deb_def() {
POSTINST_CONF_DEF="
	if ! getent group \"sshd\" > /dev/null 2>&1 ; then
	    groupadd -g 50 sshd
	fi

	if ! getent passwd \"sshd\" > /dev/null 2>&1 ; then
	    useradd -c 'sshd PrivSep' -d /var/lib/sshd -g sshd \
		    -s /bin/false -u 50 sshd
	fi
	"

POSTRM_CONF_DEF='
	if getent passwd "sshd" > /dev/null 2>&1 ; then
	    userdel sshd
	fi

	if getent group "sshd" > /dev/null 2>&1 ; then
	    groupdel sshd
	fi
	'
}

build
