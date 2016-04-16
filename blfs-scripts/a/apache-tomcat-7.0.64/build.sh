#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

configure() {
# tomcat.sh
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/tomcat.sh << "EOF"
export CATALINA_HOME=/opt/tomcat
export PATH=$PATH:$CATALINA_HOME/bin
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenJDK (>= 1.6)
Description: Servlet and JSP engine
 Apache Tomcat is an open source software implementation of the Java Servlet,
 JavaServer Pages, Java Expression Language and Java WebSocket technologies.
 The Java Servlet, JavaServer Pages, Java Expression Language and Java
 WebSocket specifications are developed under the Java Community Process.
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='
	srcfil=apache-tomcat-7.0.64.tar.gz
	srcdir=apache-tomcat-7.0.64
	'

POSTINST_CONF_DEF='
	rm -rf /opt/{$srcdir,tomcat}

	echo "start extracting files ..."
	tar -xf $srcfil -C /opt
	ln -v -nsf $srcdir /opt/tomcat
	chown -R root:root /opt/$srcdir
	'

POSTRM_FUNC_DEF='
	srcdir=apache-tomcat-7.0.64
'

POSTRM_CONF_DEF='
	rm -rf /opt/{$srcdir,tomcat}
	'
}

build
