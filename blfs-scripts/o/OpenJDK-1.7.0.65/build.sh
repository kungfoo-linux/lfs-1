#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

configure() {
# jdk.sh
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/jdk.sh << "EOF"
# Set JAVA_HOME directory
export JAVA_HOME=/opt/jdk

# Adjust PATH
export PATH=$PATH:$JAVA_HOME/bin

# Auto Java CLASSPATH
# Copy jar files to, or create symlinks in this directory

AUTO_CLASSPATH_DIR=/usr/share/java

CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

for dir in `find ${AUTO_CLASSPATH_DIR} -type d 2>/dev/null`; do
    CLASSPATH=$CLASSPATH:$dir
done

for jar in `find ${AUTO_CLASSPATH_DIR} -name "*.jar" 2>/dev/null`; do
    CLASSPATH=$CLASSPATH:$jar
done

unset AUTO_CLASSPATH_DIR dir jar
export CLASSPATH
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Replaces: OpenJDK (>= 1.6)
Conflicts: JDK (>= 6)
Description: OpenJDK Development Kit
 OpenJDK is a development environment for building applications, applets, and
 components using the Java programming language.
 .
 Runtime Dependencies:
 alsa-lib (>= 1.0.28), ATK (>= 2.12.0), Cairo (>= 1.12.16), Cups (>= 1.7.5),
 gdk-pixbuf (>= 2.30.8), giflib (>= 5.1.0), GTK+2 (>= 2.24.24), lcms2 (>= 2.6),
 Xorg-lib (>= 7.7).
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='
ARCH=`uname -m`
if [ "$ARCH" = "x86_64" ]; then
	srcfil=OpenJDK-1.7.0.65-x86_64-bin.tar.xz
	srcdir=OpenJDK-1.7.0.65-x86_64-bin
else
	srcfil=OpenJDK-1.7.0.65-i686-bin.tar.xz
	srcdir=OpenJDK-1.7.0.65-i686-bin
fi
'

POSTINST_CONF_DEF='
	rm -rf /opt/{OpenJDK-1.7.0.65,jdk}

	echo "start extracting files ..."
	tar -xf $srcfil -C /opt
	mv -v /opt/{$srcdir,OpenJDK-1.7.0.65}
	ln -v -nsf OpenJDK-1.7.0.65 /opt/jdk
	chown -R root:root /opt/OpenJDK-1.7.0.65
	'

POSTRM_CONF_DEF='rm -rf /opt/{OpenJDK-1.7.0.65,jdk}'
}

build
