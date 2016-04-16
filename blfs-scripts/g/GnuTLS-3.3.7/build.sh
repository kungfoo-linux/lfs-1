#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gnutls-3.3.7.tar.xz
srcdir=gnutls-3.3.7
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i -e '201 i#ifdef ENABLE_PKCS11' \
	-e '213 i#endif'               \
	lib/gnutls_privkey.c

./configure --prefix=/usr \
	--with-default-trust-store-file=/etc/ssl/ca-bundle.crt
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Nettle (>= 2.7.1), CA (= 7.6), libtasn1 (>= 4.1)
Description: A TLS protocol implementation
  The GnuTLS package contains libraries and userspace tools which provide a
  secure layer over a reliable transport layer. Currently the GnuTLS library
  implements the proposed standards by the IETF's TLS working group. Quoting
  from the TLS protocol specification:
  .
  “The TLS protocol provides communications privacy over the Internet. The
  protocol allows client/server applications to communicate in a way that is
  designed to prevent eavesdropping, tampering, or message forgery.”
  .
  GnuTLS provides support for TLS 1.1, TLS 1.0 and SSL 3.0 protocols, TLS
  extensions, including server name and max record size. Additionally, the
  library supports authentication using the SRP protocol, X.509 certificates
  and OpenPGP keys, along with support for the TLS Pre-Shared-Keys (PSK)
  extension, the Inner Application (TLS/IA) extension and X.509 and OpenPGP
  certificate handling.
  .
  [certtool]
  is used to generate X.509 certificates, certificate requests, and private
  keys.
  .
  [crywrap]
  is a simple wrapper that waits for TLS/SSL connections, and proxies them to
  an unencrypted location. Only installed if libidn-1.29 is present.
  .
  [danetool]
  is a tool used to generate and check DNS resource records for the DANE
  protocol.
  .
  [gnutls-cli]
  is a simple client program to set up a TLS connection to some other computer.
  .
  [gnutls-cli-debug]
  is a simple client program to set up a TLS connection to some other computer
  and produces very verbose progress results.
  .
  [gnutls-serv]
  is a simple server program that listens to incoming TLS connections.
  .
  [ocsptool]
  is a program that can parse and print information about OCSP
  requests/responses, generate requests and verify responses.
  .
  [p11tool]
  is a program that allows handling data from PKCS #11 smart cards and
  security modules.
  .
  [psktool]
  is a simple program that generates random keys for use with TLS-PSK.
  .
  [srptool]
  is a simple program that emulates the programs in the Stanford SRP
  (Secure Remote Password) libraries using GnuTLS.
  .
  [libgnutls.so]
  contains the core API functions and X.509 certificate API functions.
EOF
}

build
