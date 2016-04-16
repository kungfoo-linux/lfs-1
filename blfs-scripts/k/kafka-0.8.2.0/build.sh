#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

configure() {
# kafka.sh
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/kafka.sh << "EOF"
export KAFKA_HOME=/opt/kafka
export PATH=$PATH:$KAFKA_HOME/bin
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenJDK (>= 1.6)
Description: A high-throughput distributed messaging system.
 Apache Kafka is publish-subscribe messaging rethought as a distributed commit
 log.
 .
 Usage:
 [Start the server]
   1). Kafka uses ZooKeeper so you need to first start a ZooKeeper server if
   you don't already have one. You can use the convenience script packaged
   with kafka to get a quick-and-dirty single-node ZooKeeper instance:
 $ zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties &
   2). Now start the Kafka server:
 $ kafka-server-start.sh /opt/kafka/config/server.properties &
 .
 [Create a topic]
   Let's create a topic named "test" with a single partition and only one
   replica:
 $ kafka-topics.sh --create \\
         --zookeeper localhost:2181 \\
         --replication-factor 1 \\
         --partitions 1 \\
         --topic test
   We can now see that topic if we run the list topic command:
 $ kafka-topics.sh --list --zookeeper localhost:2181
 .
 [Send some messages]
   Kafka comes with a command line client that will take input from a file or
   from standard input and send it out as messages to the Kafka cluster. By
   default each line will be sent as a separate message.
   Run the producer and then type a few messages into the console to send to
   the server:
 $ kafka-console-producer.sh --broker-list localhost:9092 --topic test
   hello
   world
 .
 [Start a consumer]
   Kafka also has a command line consumer that will dump out messages to
   standard output:
 $ kafka-console-consumer.sh --zookeeper localhost:2181 --topic test --from-beginning
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='
	srcfil=kafka_2.10-0.8.2.0.tgz
	srcdir=kafka_2.10-0.8.2.0
	'

POSTINST_CONF_DEF='
	rm -rf /opt/{$srcdir,kafka}

	echo "start extracting files ..."
	tar -xf $srcfil -C /opt
	ln -v -nsf $srcdir /opt/kafka
	mkdir /opt/kafka/logs
	chown -R root:root /opt/$srcdir
	chmod 777 /opt/kafka/logs
	'

POSTRM_FUNC_DEF='
	srcdir=kafka_2.10-0.8.2.0
'

POSTRM_CONF_DEF='
	rm -rf /opt/{$srcdir,kafka}
	'
}

build
