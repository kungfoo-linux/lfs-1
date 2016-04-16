#!/bin/bash -e
ARCHITECTURE=x86_64
. ../../blfs.comm

configure() {
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/hadoop.sh << "EOF"
export HADOOP_HOME=/opt/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenJDK (>= 1.6)
Description: open-source software for reliable, scalable, distributed computing
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='srcfil=hadoop-2.6.0.tar.gz'

POSTINST_CONF_DEF='
	rm -rf /opt/{hadoop-2.6.0,hadoop}

	echo "start extracting files ..."
	tar -xf $srcfil -C /opt
	ln -v -nsf hadoop-2.6.0 /opt/hadoop
	chown -R root:root /opt/hadoop-2.6.0 /opt/hadoop

	ENVFILE=/opt/hadoop/etc/hadoop/hadoop-env.sh
	sed -i "s/^export JAVA_HOME=.*$/export JAVA_HOME=\/opt\/jdk/" $ENVFILE
	#echo "export HADOOP_PREFIX=/opt/hadoop" >> $ENVFILE
'

POSTRM_CONF_DEF='rm -rf /opt/{hadoop-2.6.0,hadoop}'
}

build
