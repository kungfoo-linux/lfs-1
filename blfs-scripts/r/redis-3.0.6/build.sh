#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=redis-3.0.6.tar.gz
srcdir=redis-3.0.6
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make
make PREFIX=$BUILDDIR/opt/redis-3.0.6 \
     INSTALL_BIN=$BUILDDIR/opt/redis-3.0.6 \
     install

cp redis.conf sentinel.conf $BUILDDIR/opt/redis-3.0.6
sed -i -e 's/daemonize no/daemonize yes/' \
    -e 's/#bind 127.0.0.1/bind 127.0.0.1/' \
    $BUILDDIR/opt/redis-3.0.6/redis.conf

cleanup_src .. $srcdir
}

configure() {
# redis.sh
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/redis.sh << "EOF"
export PATH=$PATH:/opt/redis-3.0.6
EOF

# redis
mkdir -pv $BUILDDIR/etc/init.d
cat > $BUILDDIR/etc/init.d/redis << "EOF"
#!/bin/bash
#
# redis    Redis is an advanced key-value store
#
# chkconfig: 2345 10 90
# description: Redis is an open source (BSD licensed), in-memory data \
#     structure store, used as database, cache and message broker. 
#             

REDIS_HOME=/opt/redis-3.0.6
REDIS_SRV=$REDIS_HOME/redis-server
REDIS_CLI=$REDIS_HOME/redis-cli
CONF=$REDIS_HOME/redis.conf
PIDFILE=/var/run/redis.pid
PASSWORD="secret"

case "$1" in
    start)
        if [ -f $PIDFILE ]; then
	    echo "$PIDFILE exists, process is already running or crashed."
        else
            echo "Starting Redis server..."
            $REDIS_SRV $CONF
        fi
        if [ "$?"="0" ]; then
            echo "Redis is running..."
        fi
        ;;

    stop)
        if [ ! -f $PIDFILE ]; then
            echo "$PIDFILE exists, process is not running."
        else
            PID=$(cat $PIDFILE)
            echo "Stopping..."
            if [ "$PASSWORD" == '' ]; then
                $REDIS_CLI shutdown
            else
                $REDIS_CLI -a "$PASSWORD" shutdown
            fi
            sleep 2

            while [ -x $PIDFILE ]; do
                echo "Waiting for Redis to shutdown..."
                sleep 1
            done
            echo "Redis stopped"
        fi
        ;;

    restart|force-reload)
        ${0} stop
        ${0} start
        ;;

    *)
        echo "Usage: /etc/init.d/redis {start|stop|restart|force-reload}" >&2
        exit 1
esac
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Persistent key-value database with network interface
 Redis is an open source (BSD licensed), in-memory data structure store, used
 as database, cache and message broker. It supports data structures such as
 strings, hashes, lists, sets, sorted sets with range queries, bitmaps,
 hyperloglogs and geospatial indexes with radius queries. Redis has built-in
 replication, Lua scripting, LRU eviction, transactions and different levels
 of on-disk persistence, and provides high availability via Redis Sentinel and
 automatic partitioning with Redis Cluster.
EOF
}

build
