#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

build_src() {
srcfil=apache-maven-3.2.5-bin.tar.gz
srcdir=apache-maven-3.2.5

install -vdm755 $BUILDDIR/opt
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil -C $BUILDDIR/opt
ln -v -nsf $srcdir $BUILDDIR/opt/mvn
chown -R root:root $BUILDDIR/opt
}

configure() {
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/mvn.sh << "EOF"
export PATH=$PATH:/opt/mvn/bin
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenJDK (>= 1.6)
Description: Java software project management and comprehension tool
 Maven is a software project management and comprehension tool. Based on the
 concept of a project object model (POM), Maven can manage a project's build,
 reporting and documentation from a central piece of information.
EOF
}

build
