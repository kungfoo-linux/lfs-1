#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=glib-2.40.0.tar.xz
srcdir=glib-2.40.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--with-pcre=system
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libffi (>= 3.1), Python2 (>= 2.7.8), PCRE (>= 8.35), elfutils (>= 0.160)
Description: common C routines used by GTK+ and other libs
 The GLib package contains a low-level libraries useful for providing data
 structure handling for C, portability wrappers and interfaces for such
 runtime functionality as an event loop, threads, dynamic loading and an
 object system.
 .
 [gdbus]
 is a simple tool used for working with D-Bus objects.
 .
 [gdbus-codegen]
 is used to generate code and/or documentation for one or more D-Bus
 interfaces.
 .
 [gio-querymodules]
 is used to create a giomodule.cache file in the listed directories. This
 file lists the implemented extension points for each module that has been
 found.
 .
 [glib-compile-resources]
 is used to read the resource description from file and the files that it
 references to create a binary resource bundle that is suitable for use with
 the GResource API.
 .
 [glib-compile-schemas]
 is used to compile all the GSettings XML schema files in directory into a
 binary file with the name gschemas.compiled that can be used by GSettings.
 .
 [glib-genmarshal]
 is a C code marshaller generation utility for GLib closures.
 .
 [glib-gettextize]
 is a variant of the gettext internationalization utility.
 .
 [glib-mkenums]
 is a C language enum description generation utility.
 .
 [gobject-query]
 is a small utility that draws a tree of types.
 .
 [gresource]
 offers a simple commandline interface to GResource.
 .
 [gsettings]
 offers a simple commandline interface to GSettings.
 .
 [gtester]
 is a test running utility.
 .
 [gtester-report]
 is a test report formatting utility.
 .
 [GLib libraries]
 contain a low-level core libraries for the GIMP Toolkit.
EOF
}

build
