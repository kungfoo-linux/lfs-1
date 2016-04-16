#!/bin/bash -e
. ../../../blfs.comm

build_src() {
srcfil=ExtUtils-Depends-0.402.tar.gz
srcdir=ExtUtils-Depends-0.402
build_standard_perl_module
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Easily build XS extensions that depend on XS extensions
 This module tries to make it easy to build Perl extensions that use functions
 and typemaps provided by other perl extensions. This means that a perl
 extension is treated like a shared library that provides also a C and an XS
 interface besides the perl one.
EOF
}

build
