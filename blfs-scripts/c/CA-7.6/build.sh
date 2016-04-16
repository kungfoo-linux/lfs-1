#!/bin/bash -e
. ../../blfs.comm

configure() {
scripts="make-cert.pl make-ca.sh remove-expired-certs.sh"
mkdir -pv $BUILDDIR/usr/bin
cp -v $scripts $BUILDDIR/usr/bin

cp -v $scripts /usr/bin                                      &&
cp $BLFSSRC/$PKGLETTER/$CURDIR/certdata.txt .                &&
make-ca.sh                                                   &&
remove-expired-certs.sh certs                                &&
rm -f certdata.txt

SSLDIR=$BUILDDIR/etc/ssl                                     &&
install -d ${SSLDIR}/certs                                   &&
cp -v certs/*.pem ${SSLDIR}/certs                            &&
c_rehash                                                     &&
install BLFS-ca-bundle*.crt ${SSLDIR}/ca-bundle.crt          &&
ln -sfv ../ca-bundle.crt ${SSLDIR}/certs/ca-certificates.crt &&
unset SSLDIR
rm -rf certs BLFS-ca-bundle*
rm -rf /usr/bin/{make-cert.pl,make-ca.sh,remove-expired-certs.sh}
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenSSL (>= 1.0.1i)
Description: Certificate Authority Certificates
 The Public Key Inrastructure is used for many security issues in a Linux
 system. In order for a certificate to be trusted, it must be signed by a
 trusted agent called a Certificate Authority (CA). The certificates loaded by
 this section are from the list on the Mozilla version control system and
 formats it into a form used by OpenSSL-1.0.1i. The certificates can also be
 used by other applications either directly of indirectly through openssl.
 .
 [make-ca.sh] is a shell script that reformats the certdata.txt file for 
 use by openssl.
 .
 [make-cert.pl] is a utility perl script that converts a single binary 
 certificate (.der format) into .pem format.
 .
 [remove-expired-certs.sh] is a utility perl script that removes expired 
 certificates from a directory. The default directory is /etc/ssl/certs. 
EOF
}

build
