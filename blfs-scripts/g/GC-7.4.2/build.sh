#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gc-7.4.2.tar.gz
srcdir=gc-7.4.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i 's#pkgdata#doc#' doc/doc.am
autoreconf -fi

./configure --prefix=/usr \
	--enable-cplusplus \
	--disable-static \
	--docdir=/usr/share/doc/gc-7.4.2
make
make DESTDIR=$BUILDDIR install

mkdir -pv $BUILDDIR/usr/share/man/man3
install -v -m644 doc/gc.man $BUILDDIR/usr/share/man/man3/gc_malloc.3
ln -sfv gc_malloc.3 $BUILDDIR/usr/share/man/man3/gc.3

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libatomic-ops (>= 7.4.2)
Description: a garbage collector for C and C++
 The GC package contains the Boehm-Demers-Weiser conservative garbage
 collector, which can be used as a garbage collecting replacement for the C
 malloc function or C++ new operator. It allows you to allocate memory
 basically as you normally would, without explicitly deallocating memory that
 is no longer useful. The collector automatically recycles memory when it
 determines that it can no longer be otherwise accessed. The collector is also
 used by a number of programming language implementations that either use C as
 intermediate code, want to facilitate easier interoperation with C libraries,
 or just prefer the simple collector interface. Alternatively, the garbage
 collector may be used as a leak detector for C or C++ programs, though that
 is not its primary goal.
 .
 [libgc.so]
 contains a C interface to the conservative garbage collector, primarily
 designed to replace the C malloc function.
 .
 [libgccpp.so]
 contains a C++ interface to the conservative garbage collector.
EOF
}

build
