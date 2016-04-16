#!/bin/bash -e
. ../../../blfs.comm

build_src() {
srcfil=Glib-1.305.tar.gz
srcdir=Glib-1.305
build_standard_perl_module
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0), \
$PERL_MODULES_PREFIX-ExtUtils-Depends (>= 0.402), \
$PERL_MODULES_PREFIX-ExtUtils-PkgConfig (>= 1.15)
Description: Perl wrappers for the GLib utility and Object libraries
 This module provides perl access to GLib and GLib's GObject libraries. GLib
 is a portability and utility library; GObject provides a generic type system
 with inheritance and a powerful signal system. Together these libraries are
 used as the foundation for many of the libraries that make up the Gnome
 environment, and are used in many unrelated projects.
EOF
}

build
