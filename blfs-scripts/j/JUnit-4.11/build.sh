#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

build_src() {
srcfil=junit4_4.11.orig.tar.gz
srcdir=junit4-4.11
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/hamcrest-1.3.tgz
cp -v hamcrest-1.3/hamcrest-core-1.3{,-sources}.jar lib
ant dist

install -v -m755 -d $BUILDDIR/usr/share/{doc,java}/junit-4.11
chown -R root:root .

cp -v -R junit*/javadoc/* $BUILDDIR/usr/share/doc/junit-4.11
cp -v junit*/junit*.jar $BUILDDIR/usr/share/java/junit-4.11
cp -v hamcrest-1.3/hamcrest-core*.jar $BUILDDIR/usr/share/java/junit-4.11

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: apache-ant (>= 1.9.4), UnZip (>= 6.0)
Description: Automated testing framework for Java
 JUnit is a simple framework for writing and running automated tests. As a
 political gesture, it celebrates programmers testing their own software.
EOF
}

build
