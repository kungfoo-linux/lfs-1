#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

configure() {
# groovy.sh
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/groovy.sh << "EOF"
export GROOVY_HOME=/opt/groovy
export PATH=$PATH:$GROOVY_HOME/bin
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenJDK (>= 1.6)
Description: A multi-faceted language for the Java platform
 Groovy is a powerful, optionally typed and dynamic language, with
 static-typing and static compilation capabilities, for the Java platform
 aimed at multiplying developers’ productivity thanks to a concise, familiar
 and easy to learn syntax. It integrates smoothly with any Java program, and
 immediately delivers to your application powerful features, including
 scripting capabilities, Domain-Specific Language authoring, runtime and
 compile-time meta-programming and functional programming.
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='
	srcfil=apache-groovy-binary-2.4.4.zip
	srcdir=groovy-2.4.4
	'

POSTINST_CONF_DEF='
	rm -rf /opt/{$srcdir,groovy}

	echo "start extracting files ..."
	unzip -q $srcfil -d /opt
	ln -v -nsf $srcdir /opt/groovy
	chown -R root:root /opt/$srcdir
	'

POSTRM_FUNC_DEF='
	srcdir=groovy-2.4.4
	'

POSTRM_CONF_DEF='
	rm -rf /opt/{$srcdir,groovy}
	'
}

build
