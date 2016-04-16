#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=swig-3.0.2.tar.gz
srcdir=swig-3.0.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

install -v -m755 -d $BUILDDIR/usr/share/doc/swig-3.0.2
cp -v -R Doc/* $BUILDDIR/usr/share/doc/swig-3.0.2

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: PCRE (>= 8.35)
Description: Simplified Wrapper and Interface Generator
  SWIG (Simplified Wrapper and Interface Generator) is a compiler that
  integrates C and C++ with languages including Perl, Python, Tcl, Ruby, PHP,
  Java, C#, D, Go, Lua, Octave, R, Scheme, Ocaml, Modula-3, Common Lisp, and
  Pike. SWIG can also export its parse tree into Lisp s-expressions and XML.
  SWIG reads annotated C/C++ header files and creates wrapper code (glue code)
  in order to make the corresponding C/C++ libraries available to the listed
  languages, or to extend C/C++ programs with a scripting language.
  .
  [swig]
  takes an interface file containing C/C++ declarations and SWIG special
  instructions, and generates the corresponding wrapper code needed to build
  extension modules.
  .
  [ccache-swig]
  is a compiler cache, which speeds up re-compilation of C/C++/SWIG code.
EOF
}

build
