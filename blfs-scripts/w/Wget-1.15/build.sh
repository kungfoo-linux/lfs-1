#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=wget-1.15.tar.xz
srcdir=wget-1.15
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--with-ssl=openssl
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenSSL (>= 1.0.1i), libidn (>= 1.29), PCRE (>= 8.35)
Description: retrieves files from the web
 Wget is a network utility to retrieve files from the web using HTTP(S) and
 FTP, the two most widely used internet protocols. It works non-interactively,
 so it will work in the background, after having logged off. The program
 supports recursive retrieval of web-authoring pages as well as FTP sites --
 you can use Wget to make mirrors of archives and home pages or to travel the
 web like a WWW robot.
 .
 Wget works particularly well with slow or unstable connections by continuing
 to retrieve a document until the document is fully downloaded. Re-getting
 files from where it left off works on servers (both HTTP and FTP) that
 support it. Both HTTP and FTP retrievals can be time stamped, so Wget can see
 if the remote file has changed since the last retrieval and automatically
 retrieve the new version if it has.
 .
 Wget supports proxy servers; this can lighten the network load, speed up
 retrieval, and provide access behind firewalls.
 .
 [wget]
 retrieves files from the Web using the HTTP, HTTPS and FTP protocols. It is
 designed to be non-interactive, for background or unattended operations.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	echo -e \
	" If you have installed the Certificate Authority Certificates (CA-7.4)\n" \
	"and you want Wget to use them, as the root user:\n" \
	"echo ca-directory=/etc/ssl/certs >> /etc/wgetrc"
	'
}

build
