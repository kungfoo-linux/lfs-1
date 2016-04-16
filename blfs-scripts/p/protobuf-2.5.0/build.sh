#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=protobuf-2.5.0.tar.bz2
srcdir=protobuf-2.5.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Protocol Buffers - Google's data interchange format
 Protocol buffers are Google's language-neutral, platform-neutral, 
 extensible mechanism for serializing structured data think XML, but 
 smaller, faster, and simpler. You define how you want your data to be 
 structured once, then you can use special generated source code to 
 easily write and read your structured data to and from a variety of data 
 streams and using a variety of languages Java, C++, or Python.
 .
 [protoc] .proto file compiler
 .
 [libprotoc.so] contains the core API functions to manipulate protobuf
 structure.
EOF
}

build
