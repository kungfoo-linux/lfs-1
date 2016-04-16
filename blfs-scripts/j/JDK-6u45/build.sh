#!/bin/bash -e
. ../../blfs.comm

build_src() {
case `uname -m` in
    i?86)
        srcfil=jdk-6u45-linux-i586.bin
	srcdir=jdk1.6.0_45
	;;

    x86_64)
        srcfil=jdk-6u45-linux-x64.bin
	srcdir=jdk1.6.0_45
	;;
esac

install -vdm755 $BUILDDIR/opt
pushd $BUILDDIR/opt

$BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
mv -v $srcdir JDK-6u45
chown -R root:root JDK-6u45

# fixes linking issues with other applications that expect to find the motif
# libraries with the other JDK libraries:
ln -svf xawt/libmawt.so JDK-6u45/jre/lib/i386/

# Recent versions of libX11 break libmawt when used with the Xinerama
# extension, apply the following sed to work around this problem:
sed -i 's@XINERAMA@FAKEEXTN@g' JDK-6u45/jre/lib/i386/xawt/libmawt.so

popd

rm -fv $BUILDDIR/opt/JDK-6u45/src.zip
strip_debug
}

configure() {
ln -v -nsf JDK-6u45 $BUILDDIR/opt/jdk

# /etc/profile.d/jdk.sh
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/openjdk.sh << "EOF"
export CLASSPATH=.:/usr/share/java
export JAVA_HOME=/opt/jdk
export PATH=$PATH:$JAVA_HOME/bin
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Replaces: JDK (>= 6)
Conflicts: OpenJDK (>= 1.6)
Description: Sun(Oracle) Java Development Kit
 Java Platform, Standard Edition (Java SE) lets you develop and deploy Java
 applications on desktops and servers, as well as in today's demanding
 embedded environments. Java offers the rich user interface, performance,
 versatility, portability, and security that today's applicationsrequire.
 .
 Runtime Dependencies:
 alsa-lib (>= 1.0.28), ATK (>= 2.12.0), Cairo (>= 1.12.16), Cups (>= 1.7.5),
 gdk-pixbuf (>= 2.30.8), giflib (>= 5.1.0), GTK+2 (>= 2.24.24), lcms2 (>= 2.6),
 Xorg-lib (>= 7.7).
EOF
}

build
