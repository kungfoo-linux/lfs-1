#!/bin/bash -e
. ../../blfs.comm

build_src() {
version=3.2.8
srcfil=redis-$version.tar.gz
srcdir=redis-$version
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make
make PREFIX=$BUILDDIR/opt/redis-$version \
     INSTALL_BIN=$BUILDDIR/opt/redis-$version \
     install
install -d -m777 $BUILDDIR/opt/redis-$version/data
ln -sv redis-$version $BUILDDIR/opt/redis

cp redis.conf sentinel.conf $BUILDDIR/opt/redis-$version
sed -i -e 's/^daemonize no/daemonize yes/' \
    -e 's/^port 6379/port 16379/' \
    -e 's/^# bind 127.0.0.1/bind 127.0.0.1/' \
    -e 's/^pidfile \/var\/run\/redis_6379.pid/pidfile \/var\/run\/redis.pid/' \
    -e 's/^dir .\//dir \/opt\/redis\/data\//' \
    $BUILDDIR/opt/redis-$version/redis.conf

cleanup_src .. $srcdir
}

configure() {
# redis.sh
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/redis.sh << "EOF"
export PATH=$PATH:/opt/redis
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
 .
 start redis: sudo -u nobody /opt/redis/redis-server /opt/redis/redis.conf
 stop  redis: /opt/redis/redis-cli -p 16379 shutdown
EOF
}

build
