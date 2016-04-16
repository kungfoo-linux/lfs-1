#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=icu4c-53_1-src.tgz
srcdir=icu
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir/source

CXX=g++ ./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: International Components for Unicode
 The International Components for Unicode (ICU) package is a mature, widely
 used set of C/C++ libraries providing Unicode and Globalization support for
 software applications. ICU is widely portable and gives applications the same
 results on all platforms.
 .
 [derb]
 disassembles a resource bundle.
 .
 [genbrk]
 compiles ICU break iteration rules source files into binary data files.
 .
 [genccode]
 generates C or platform specific assembly code from an ICU data file.
 .
 [gencfu]
 reads in Unicode confusable character definitions and writes out the binary
 data.
 .
 [gencmn]
 generates an ICU memory-mappable data file.
 .
 [gencnval]
 compiles the converter's aliases file.
 .
 [gendict]
 compiles word list into ICU string trie dictionary.
 .
 [genrb]
 compiles a resource bundle.
 .
 [gensprep]
 compiles StringPrep data from filtered RFC 3454 files.
 .
 [icu-config]
 outputs ICU build options.
 .
 [icuinfo]
 outputs configuration information about the current ICU.
 .
 [icupkg]
 extracts or modifies an ICU .dat archive.
 .
 [makeconv]
 compiles a converter table.
 .
 [pkgdata]
 packages data for use by ICU.
 .
 [uconv]
 converts data from one encoding to another.
 .
 [libicudata.so]
 is the data library.
 .
 [libicui18n.so]
 is the internationalization (i18n) library.
 .
 [libicuio.so]
 is the ICU I/O (unicode stdio) library.
 .
 [libicule.so]
 is the layout engine.
 .
 [libiculx.so]
 is the layout extensions engine.
 .
 [libicutest.so]
 is the test library.
 .
 [libicutu.so]
 is the tool utility library.
 .
 [libicuuc.so]
 is the common library. 
EOF
}

build
