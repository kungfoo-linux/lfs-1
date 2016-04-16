#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=aspell-0.60.6.1.tar.gz
srcdir=aspell-0.60.6.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install
install -v -m755 -d $BUILDDIR/usr/share/doc/aspell-0.60.6.1/aspell{,-dev}.html
install -v -m644 manual/aspell.html/* \
	$BUILDDIR/usr/share/doc/aspell-0.60.6.1/aspell.html
install -v -m644 manual/aspell-dev.html/* \
	$BUILDDIR/usr/share/doc/aspell-0.60.6.1/aspell-dev.html

# for build aspell directory
make install

cleanup_src .. $srcdir

# After Aspell is installed, you must set up at least one dictionary.
# Install one or more dictionaries by running the following commands
# (english directory for example):

srcfil=aspell6-en-7.1-0.tar.bz2
srcdir=aspell6-en-7.1-0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Which (>= 2.20)
Description: a free and open source spell checker
 The Aspell package contains an interactive spell checking program and the
 Aspell libraries. Aspell can either be used as a library or as an independent
 spell checker.
 .
 [aspell]
 is a utility that can function as an ispell -a replacement, as an independent
 spell checker, as a test utility to test out Aspell features, and as a
 utility for managing dictionaries.
 .
 [ispell]
 is a wrapper around aspell to invoke it in ispell compatible mode.
 .
 [spell]
 is a wrapper around aspell to invoke it in spell compatible mode.
 .
 [aspell-import]
 imports old personal dictionaries into Aspell.
 .
 [precat]
 decompresses a prezipped file to stdout.
 .
 [preunzip]
 decompresses a prezipped file.
 .
 [prezip]
 is a prefix delta compressor, used to compress sorted word lists or other
 similar text files.
 .
 [prezip-bin]
 is called by the various wrapper scripts to perform the actual compressing
 and decompressing.
 .
 [pspell-config]
 displays information about the libpspell installation, mostly for use in
 build scripts.
 .
 [run-with-aspell]
 is a script to help use Aspell as an ispell replacement.
 .
 [word-list-compress]
 compresses or decompresses sorted word lists for use with the Aspell spell
 checker.
 .
 [libaspell.so]
 contains spell checking API functions.
 .
 [libpspell.so]
 is an interface to the libaspell library. All the spell checking
 functionality is now in libaspell but this library is included for backward
 compatibility.
EOF
}

build
