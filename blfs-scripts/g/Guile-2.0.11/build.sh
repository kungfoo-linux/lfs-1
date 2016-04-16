#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=guile-2.0.11.tar.xz
srcdir=guile-2.0.11
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/guile-2.0.11
make
make html
makeinfo --plaintext -o doc/r5rs/r5rs.txt doc/r5rs/r5rs.texi
makeinfo --plaintext -o doc/ref/guile.txt doc/ref/guile.texi
make DESTDIR=$BUILDDIR install
make DESTDIR=$BUILDDIR install-html
mv $BUILDDIR/usr/share/doc/guile-2.0.11/{guile.html,ref}
mv $BUILDDIR/usr/share/doc/guile-2.0.11/r5rs{.html,}
find examples -name "Makefile*" -delete
cp -vR examples $BUILDDIR/usr/share/doc/guile-2.0.11

for DIRNAME in r5rs ref; do
	install -v -m644  doc/${DIRNAME}/*.txt \
		$BUILDDIR/usr/share/doc/guile-2.0.11/${DIRNAME}
done
unset DIRNAME

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GC (>= 7.4.2), libffi (>= 3.1), libunistring (>= 0.9.4)
Description: GNU's Ubiquitous Intelligent Language for Extension
 The Guile package contains the Project GNU's extension language library.
 Guile also contains a stand alone Scheme interpreter.
 .
 [guile]
 is a stand-alone Scheme interpreter for Guile.
 .
 [guile-config]
 is a Guile script which provides the information necessary to link your
 programs against the Guile library, in much the same way PkgConfig does.
 .
 [guile-snarf]
 is a script to parse declarations in your C code for Scheme visible C
 functions.
 .
 [guild]
 is a wrapper program installed along with guile, which knows where a
 particular module is installed and calls it, passing its arguments to the
 program.
 .
 [guile-tools]
 is a symlink to guild.
EOF
}

build
