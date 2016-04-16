#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=tcl8.6.2-src.tar.gz
srcdir=tcl8.6.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/tcl8.6.2-html.tar.gz --strip-components=1

export SRCDIR=`pwd`
cd unix

./configure --prefix=/usr \
	--without-tzdata \
	--mandir=/usr/share/man \
	$([ $(uname -m) = x86_64 ] && echo --enable-64bit)
make

sed -e "s#$SRCDIR/unix#/usr/lib#" \
    -e "s#$SRCDIR#/usr/include#"  \
    -i tclConfig.sh               &&

sed -e "s#$SRCDIR/unix/pkgs/tdbc1.0.1#/usr/lib/tdbc1.0.0#" \
    -e "s#$SRCDIR/pkgs/tdbc1.0.1/generic#/usr/include#"    \
    -e "s#$SRCDIR/pkgs/tdbc1.0.1/library#/usr/lib/tcl8.6#" \
    -e "s#$SRCDIR/pkgs/tdbc1.0.1#/usr/include#"            \
    -i pkgs/tdbc1.0.1/tdbcConfig.sh                        &&

sed -e "s#$SRCDIR/unix/pkgs/itcl4.0.1#/usr/lib/itcl4.0.0#" \
    -e "s#$SRCDIR/pkgs/itcl4.0.1/generic#/usr/include#"    \
    -e "s#$SRCDIR/pkgs/itcl4.0.1#/usr/include#"            \
    -i pkgs/itcl4.0.1/itclConfig.sh                        &&

unset SRCDIR

make DESTDIR=$BUILDDIR install
make DESTDIR=$BUILDDIR install-private-headers
ln -v -sf tclsh8.6 $BUILDDIR/usr/bin/tclsh
chmod -v 755 $BUILDDIR/usr/lib/libtcl8.6.so

mkdir -v -p $BUILDDIR/usr/share/doc/tcl-8.6.2
cp -v -r  ../html/* $BUILDDIR/usr/share/doc/tcl-8.6.2

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Homepage: http://www.tcl.tk/
Description: The Tcl Programming Language
 The Tcl package contains the Tool Command Language, a robust general-purpose
 scripting language.
 .
 [tclsh]
 is a symlink to the tclsh8.6 program.
 .
 [tclsh8.6]
 is a simple shell containing the Tcl interpreter.
 .
 [libtcl8.6.so]
 contains the API functions required by Tcl.
EOF
}

build
