#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=grantlee-0.4.0.tar.gz
srcdir=grantlee-0.4.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_BUILD_TYPE=Release \
	..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Qt4 (>= 4.8.6)
Description: Qt string template engine based on the Django template system
 Grantlee is a plugin based String Template system written using the Qt
 framework. The goals of the project are to make it easier for application
 developers to separate the structure of documents from the data they contain,
 opening the door for theming. The syntax is intended to follow the syntax of
 the Django template system, and the design of Django is reused in Grantlee.
 Django is covered by a BSD style license. Part of the design of both is that
 application developers can extend the syntax by implementing their own tags
 and filters. For details of how to do that, see the API documentation. For
 template authors, different applications using Grantlee will present the same
 interface and core syntax for creating new themes. For details of how to
 write templates, see the documentation.
EOF
}

build
