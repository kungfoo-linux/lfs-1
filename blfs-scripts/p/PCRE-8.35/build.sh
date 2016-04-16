#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=pcre-8.35.tar.bz2
srcdir=pcre-8.35
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--docdir=/usr/share/doc/pcre-8.35 \
	--enable-unicode-properties \
	--enable-pcre16 \
	--enable-pcre32 \
	--enable-pcregrep-libz \
	--enable-pcregrep-libbz2 \
	--enable-pcretest-libreadline \
	--disable-static
make
make DESTDIR=$BUILDDIR install

mkdir -pv $BUILDDIR/lib
mv -v $BUILDDIR/usr/lib/libpcre.so.* $BUILDDIR/lib
ln -sfv ../../lib/$(readlink $BUILDDIR/usr/lib/libpcre.so) \
	$BUILDDIR/usr/lib/libpcre.so

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Perl-compatible regular expression library
 PCRE is a library implementing Perl Compatible Regular Expressions.
 .
 [pcregrep] is a grep that understands Perl compatible regular expressions.
 .
 [pcretest] can test a Perl compatible regular expression.
 .
 [pcre-config] is used during the compile process of programs linking to the
 PCRE libraries. 
EOF
}

build
