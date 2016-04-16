#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=httpd-2.4.10.tar.bz2
srcdir=httpd-2.4.10
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/httpd-2.4.10-blfs_layout-1.patch
sed '/dir.*CFG_PREFIX/s@^@#@' -i support/apxs.in

./configure --enable-authnz-fcgi \
	--enable-layout=BLFS \
	--enable-mods-shared="all cgi" \
	--enable-mpms-shared=all \
	--enable-suexec=shared \
	--with-apr=/usr/bin/apr-1-config \
	--with-apr-util=/usr/bin/apu-1-config \
	--with-suexec-bin=/usr/lib/httpd/suexec \
	--with-suexec-caller=apache \
	--with-suexec-docroot=/srv/www \
	--with-suexec-logfile=/var/log/httpd/suexec.log \
	--with-suexec-uidmin=100 \
	--with-suexec-userdir=public_html 
make
make DESTDIR=$BUILDDIR install

mv -v $BUILDDIR/usr/sbin/suexec $BUILDDIR/usr/lib/httpd/suexec
chgrp apache $BUILDDIR/usr/lib/httpd/suexec
chmod 4754 $BUILDDIR/usr/lib/httpd/suexec
chown -v -R apache:apache $BUILDDIR/srv/www

cleanup_src .. $srcdir
}

configure() {
# To avoid the warning "httpd: Could not reliably determine the server's fully
# qualified domain name, using 127.0.0.1 for ServerName", modify the
# httpd.conf file:
sed -i "s/^#ServerName/ServerName/" $BUILDDIR/etc/httpd/httpd.conf

# See file:///usr/share/httpd/manual/configuring.html for detailed
# instructions on customising your Apache HTTP server configuration file.
true
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Apr-Util (>= 1.5.3), PCRE (>= 8.35), OpenSSL (>= 1.0.1i), \
BerkeleyDB (>= 6.1.19), libxml2 (>= 2.9.1), Lua (>= 5.2.3)
Description: The most widely used Web server on the Internet
 The Apache Project is a collaborative software development effort aimed at
 creating a robust, commercial-grade, featureful, and freely-available source
 code implementation of an HTTP (Web) server. The project is jointly managed
 by a group of volunteers located around the world, using the Internet and the
 Web to communicate, plan, and develop the server and its related
 documentation. These volunteers are known as the Apache Group. In addition,
 hundreds of users have contributed ideas, code, and documentation to the
 project.
 .
 Note that the /srv/www is the apache's home directory. For normal, the file
 index.html in /srv/www/htdocs directory is the homepage.
 .
 You can start the apache manual:
     /usr/sbin/httpd    or:
     /usr/sbin/apachectl start
 If you want the Apache server to start automatically when the system is
 booted, install the /etc/rc.d/init.d/httpd init script included in the
 blfs-bootscripts-20140919 package.
     make install-httpd
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	if ! getent group "apache" > /dev/null 2>&1 ; then
	    groupadd -g 25 apache
	fi

	if ! getent passwd "apache" > /dev/null 2>&1 ; then
	    useradd -c "Apache Server" -d /srv/www -g apache \
	        -s /bin/false -u 25 apache
	fi
	'

POSTRM_CONF_DEF='
	if getent passwd "apache" > /dev/null 2>&1 ; then
	    userdel apache
	fi

	if getent group "apache" > /dev/null 2>&1 ; then
	    groupdel apache
	fi
	'
}

build
