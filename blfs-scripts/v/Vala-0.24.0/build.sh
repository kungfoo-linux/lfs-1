#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=vala-0.24.0.tar.xz
srcdir=vala-0.24.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/vala-0.24.0-upstream_fixes-2.patch

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0)
Description: programming language for GNOME
 Vala is a new programming language that aims to bring modern programming
 language features to GNOME developers without imposing any additional runtime
 requirements and without using a different ABI compared to applications and
 libraries written in C.
 .
 [valac]
 is a compiler that translates Vala source code into C source and header
 files.
 .
 [vala-gen-introspect]
 generates a GI file for GObject and GLib based packages.
 .
 [vapicheck]
 verifies the generated bindings.
 .
 [vapigen]
 is a utility which generates Vala API (VAPI) files from GI files.
 .
 [libvala-0.24.so]
 contains the Vala API functions. 
EOF
}

build
