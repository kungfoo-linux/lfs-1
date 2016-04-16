#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

configure() {
# gradle.sh
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/gradle.sh << "EOF"
export GRADLE_HOME=/opt/gradle
export PATH=$PATH:$GRADLE_HOME/bin
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenJDK (>= 1.6)
Description: build automation for the JVM, Android, and C/C++
 Gradle is an open source build automation system. Gradle can automate the
 building, testing, publishing, deployment and more of software packages or
 other types of projects such as generated static websites, generated
 documentation or indeed anything else.
 Gradle combines the power and flexibility of Ant with the dependency
 management and conventions of Maven into a more effective way to build.
 Powered by Build Programming Language, Gradle is concise yet expressive.
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='
	srcfil=gradle-2.4-bin.zip
	srcdir=gradle-2.4
	'

POSTINST_CONF_DEF='
	rm -rf /opt/{$srcdir,gradle}

	echo "start extracting files ..."
	unzip $srcfil -d /opt
	ln -v -nsf $srcdir /opt/gradle
	chown -R root:root /opt/$srcdir
	'

POSTRM_FUNC_DEF='
	srcdir=gradle-2.4
'

POSTRM_CONF_DEF='
	rm -rf /opt/{$srcdir,gradle}
	'
}

build
