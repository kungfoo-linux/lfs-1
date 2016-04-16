#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

configure() {
# ant.sh
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/ant.sh << "EOF"
export ANT_HOME=/opt/ant
export PATH=$PATH:$ANT_HOME/bin
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenJDK (>= 1.6)
Description: Java based build tool like make
 The Apache Ant package is a Java-based build tool. In theory, it is kind of
 like make, but without make's wrinkles. Ant is different. Instead of a model
 that is extended with shell-based commands, Ant is extended using Java
 classes. Instead of writing shell commands, the configuration files are
 XML-based, calling out a target tree that executes various tasks. Each task
 is run by an object that implements a particular task interface.
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='
	srcfil=apache-ant-1.9.4-bin.tar.bz2
	srcdir=apache-ant-1.9.4
	'

POSTINST_CONF_DEF='
	rm -rf /opt/{$srcdir,ant}

	echo "start extracting files ..."
	tar -xf $srcfil -C /opt
	ln -v -nsf $srcdir /opt/ant
	chown -R root:root /opt/$srcdir
	'

POSTRM_FUNC_DEF='
	srcdir=apache-ant-1.9.4
'

POSTRM_CONF_DEF='
	rm -rf /opt/{$srcdir,ant}
	'
}

build
