#!/bin/bash -e
ARCHITECTURE=x86_64
. ../../blfs.comm

configure() {
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/spark.sh << "EOF"
export SPARK_HOME=/opt/spark
export PATH=$PATH:$SPARK_HOME/bin
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenJDK (>= 1.6), Scala (>= 2.10)
Description: Lightning-fast cluster computing
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF="srcfil=spark-1.2.1-bin-hadoop2.4.tgz"

POSTINST_CONF_DEF='
	rm -rf /opt/spark /opt/spark-1.2.1-bin-hadoop2.4
	echo "start extracting files ..."
	tar -xf $srcfil -C /opt
	ln -v -nsf spark-1.2.1-bin-hadoop2.4 /opt/spark
	chown -R root:root /opt/spark /opt/spark-1.2.1-bin-hadoop2.4

#ENVFILE=/opt/hadoop/etc/hadoop/hadoop-env.sh
#sed -i "s/^export JAVA_HOME=.*$/export JAVA_HOME=\/opt\/jdk/" $ENVFILE
#echo "export HADOOP_PREFIX=/opt/hadoop" >> $ENVFILE
'

POSTRM_CONF_DEF='
	rm -rf /opt/spark /opt/spark-1.2.1-bin-hadoop2.4
	'
}

build
