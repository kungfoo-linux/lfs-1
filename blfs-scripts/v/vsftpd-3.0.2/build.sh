#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=vsftpd-3.0.2.tar.gz
srcdir=vsftpd-3.0.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make

mkdir -pv $BUILDDIR/{usr/{sbin,share/man/{man5,man8}},etc}
install -v -m 755 vsftpd	$BUILDDIR/usr/sbin/vsftpd
install -v -m 644 vsftpd.8	$BUILDDIR/usr/share/man/man8
install -v -m 644 vsftpd.conf.5 $BUILDDIR/usr/share/man/man5
install -v -m 644 vsftpd.conf	$BUILDDIR/etc/vsftpd.conf.example
install -dv -m 0755 		$BUILDDIR/usr/share/vsftpd/empty
install -dv -m 0755 		$BUILDDIR/home/ftp

cleanup_src .. $srcdir
}

configure() {
cat > $BUILDDIR/etc/vsftpd.conf << "EOF"
background=YES
nopriv_user=vsftpd
secure_chroot_dir=/usr/share/vsftpd/empty
no_anon_password=YES
anon_other_write_enable=YES
anon_umask=022

#listen=YES
#local_enable=YES
#write_enable=YES
#local_umask=022
#anon_upload_enable=YES
#anon_mkdir_write_enable=YES
#chown_uploads=YES
#idle_session_timeout=600
#data_connection_timeout=120
#ftpd_banner=Welcome to Fangxm FTP server.
#ls_recurse_enable=YES
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: openssl (>= 1.0.1i)
Suggests: Linux-PAM-1.1.8
Description: lightweight, efficient FTP server written for security
 If you want start the vsftpd daemon at system start, install the 
 /etc/rc.d/init.d/vsftpd init script included in the blfs-bootscripts-20140919
 package:
 $ make install-vsftpd
 .
 or start the daemon manual:
 $ vsftpd &
 .
 Simple test:
 As the above setting, the FTP's home directory is "/home/ftp/". 
 Now we copy some files and directories into it:
 $ cd /home/ftp
 $ install -dv {tmp,upload}
 $ echo a > a.txt && echo b > tmp/b.txt && echo c > upload/c.txt
 $ chown ftp upload
 .
 Ok, if all is well, you can now connect this FTP server 
 (the normal user name is "ftp", and none password):
 $ ftp localhost	/* or "ftp 192.168.1.10" */
 $ pwd			/* print current directory. */
 $ ls			/* list contents of current directory. */
 $ get a.txt /tmp/a.txt	/* download file a.txt to /tmp/a.txt. */
 $ cd upload
 $ put /tmp/a.txt	/* upload file /tmp/a.txt. */
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	if ! getent group "vsftpd" > /dev/null 2>&1 ; then
	    groupadd -g 47 vsftpd
	fi

	if ! getent group "ftp" > /dev/null 2>&1 ; then
	    groupadd -g 45 ftp
	fi

	if ! getent passwd "vsftpd" > /dev/null 2>&1 ; then
	    useradd -c "vsftpd User"  -d /dev/null -g vsftpd \
		    -s /bin/false -u 47 vsftpd
	fi

	if ! getent passwd "ftp" > /dev/null 2>&1 ; then
	    useradd -c anonymous_user -d /home/ftp -g ftp \
		    -s /bin/false -u 45 ftp
	fi
	'

POSTRM_CONF_DEF='
	if getent passwd "vsftpd" > /dev/null 2>&1 ; then
	    userdel vsftpd
	fi

	if getent passwd "ftp" > /dev/null 2>&1 ; then
	    userdel ftp
	fi

	if getent group "vsftpd" > /dev/null 2>&1 ; then
	    groupdel vsftpd
	fi

	if getent group "ftp" > /dev/null 2>&1 ; then
	    groupdel ftp
	fi
	'
}

build
