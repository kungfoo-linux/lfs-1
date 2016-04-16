#!/bin/bash -e
. ../../../blfs.comm

build_src() {
srcfil=ExtUtils-PkgConfig-1.15.tar.gz
srcdir=ExtUtils-PkgConfig-1.15
build_standard_perl_module
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: simplistic interface to pkg-config
 ExtUtils::PkgConfig is a very simplistic interface to this utility, intended
 for use in the Makefile.PL of perl extensions which bind libraries that
 pkg-config knows. It is really just boilerplate code that you would've
 written yourself.
EOF
}

build
