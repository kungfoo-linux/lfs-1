#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

configure() {
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/scala.sh << "EOF"
export SCALA_HOME=/opt/scala
export PATH=$PATH:$SCALA_HOME/bin
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenJDK (>= 1.6)
Description: Scala programming language
 Scala is a Java-compatible programming language with many modern language
 features. It is Java-compatible in that Scala and Java classes can directly
 reference each other and subclass each other with no glue code needed. It
 includes modern language features such as closures, pattern-matching,
 parametric types, and virtual type members.
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='
	srcfil=scala-2.11.5.tgz
	srcdir=scala-2.11.5
	'

POSTINST_CONF_DEF='
	rm -rf /opt/{$srcdir,scala}

	echo "start extracting files ..."
	tar -xf $srcfil -C /opt
	ln -v -nsf $srcdir /opt/scala
	chown -R root:root /opt/$srcdir
	'

POSTRM_FUNC_DEF='
	srcdir=scala-2.11.5
'

POSTRM_CONF_DEF='
	rm -rf /opt/{$srcdir,scala}
	'
}

build
