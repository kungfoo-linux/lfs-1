#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=ncurses-ruby-1.3.1.tar.bz2
srcdir=ncurses-ruby-1.3.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

ruby extconf.rb
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Ruby (>= 1.8)
Description: ruby extension for the ncurses C library
 All C functions are wrapped by module functions of the module "Ncurses", with
 exactly the same name. Additionally, C functions expecting a WINDOW* as their
 first argument can also be called as methods of the "Ncurses::WINDOW" class.
 .
 To test that the library installed in the correct location, you can run this
 command (it should print "true"): 
      ruby -e "p(require 'ncurses')"
EOF
}

build
