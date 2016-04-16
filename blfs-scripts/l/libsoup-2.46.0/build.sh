#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libsoup-2.46.0.tar.xz
srcdir=libsoup-2.46.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: glib-networking (>= 2.40.1), libxml2 (>= 2.9.1), SQLite (>= 3.8.6), \
gobject-introspection (>= 1.40.0)
Description: HTTP library implementation in C
 It was originally part of a SOAP (Simple Object Access Protocol)
 implementation called Soup, but the SOAP and non-SOAP parts have now been
 split into separate packages.
 .
 libsoup uses the Glib main loop and is designed to work well with GTK+
 applications. This enables GNOME applications to access HTTP servers on the
 network in a completely asynchronous fashion, very similar to the GTK+
 programming model (a synchronous operation mode is also supported for those
 who want it).
 .
 Features:
  * Both asynchronous (GMainLoop and callback-based) and synchronous APIs
  * Automatically caches connections
  * SSL Support using GnuTLS
  * Proxy support, including authentication and SSL tunneling
  * Client support for Digest, NTLM, and Basic authentication
  * Server support for Digest and Basic authentication
  * Basic client-side SOAP and XML-RPC support
 .
 [libsoup-2.4.so]
 provides functions for asynchronous HTTP connections.
 .
 [libsoup-gnome-2.4.so]
 provides GNOME specific features. 
EOF
}

build
