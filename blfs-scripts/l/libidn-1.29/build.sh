#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libidn-1.29.tar.gz
srcdir=libidn-1.29
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

find doc -name "Makefile*" -delete &&
rm -rf -v doc/{gdoc,idn.1,stamp-vti,man,texi} &&
mkdir -pv $BUILDDIR/usr/share/doc/libidn-1.29 &&
cp -r -v doc/* $BUILDDIR/usr/share/doc/libidn-1.29

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Internationalized Domain Names (IDN) support library
 libidn is a package designed for internationalized string handling based on
 the Stringprep, Punycode and IDNA specifications defined by the Internet
 Engineering Task Force (IETF) Internationalized Domain Names (IDN) working
 group, used for internationalized domain names. This is useful for converting
 data from the system's native representation into UTF-8, transforming Unicode
 strings into ASCII strings, allowing applications to use certain ASCII name
 labels (beginning with a special prefix) to represent non-ASCII name labels,
 and converting entire domain names to and from the ASCII Compatible Encoding
 (ACE) form.
 .
 [idn]
 is a command line interface to the internationalized domain name library.
 .
 [libidn.so]
 contains a generic Stringprep implementation that does Unicode 3.2 NFKC
 normalization, mapping and prohibition of characters, and bidirectional
 character handling. Profiles for Nameprep, iSCSI, SASL and XMPP are included
 as well as support for Punycode and ASCII Compatible Encoding (ACE) via IDNA.
 A mechanism to define Top-Level Domain (TLD) specific validation tables, and
 to compare strings against those tables, as well as default tables for some
 TLDs are included.
EOF
}

build
