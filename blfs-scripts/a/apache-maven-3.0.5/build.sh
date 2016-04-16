#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

configure() {
# maven.sh
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/maven.sh << "EOF"
export M2_HOME=/opt/maven
export PATH=$PATH:$M2_HOME/bin
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

set_deb_def() {
POSTINST_FUNC_DEF='
	srcfil=apache-maven-3.0.5-bin.tar.gz
	srcdir=apache-maven-3.0.5
	'

POSTINST_CONF_DEF='
	rm -rf /opt/{$srcdir,maven}

	echo "start extracting files ..."
	tar -xf $srcfil -C /opt
	ln -v -nsf $srcdir /opt/maven
	chown -R root:root /opt/$srcdir
	'

POSTRM_FUNC_DEF='
	srcdir=apache-maven-3.0.5
'

POSTRM_CONF_DEF='
	rm -rf /opt/{$srcdir,maven}
	'
}

build
