#!/bin/bash -e
. ../../blfs.comm

build_src() {
    version=5.6.29
    srcfil=mysql-$version.tar.gz
    srcdir=mysql-$version
    prefix=/opt/mysql-$version
    tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
    cd $srcdir
    pushd .

    mkdir build && cd build
    cmake -DCMAKE_INSTALL_PREFIX=$prefix \
        -DCMAKE_BUILD_TYPE=Release \
        -DWITH_INNODB_MEMCACHED=ON \
        -DWITH_LIBWRAP=OFF \
        -DWITH_NUMA=ON \
        -DWITH_SSL=bundled \
        -DWITH_ZLIB=bundled \
        ..

        #-DENABLE_MEMCACHED_SASL=ON
        #-DENABLE_MEMCACHED_SASL_PWDB=ON

    make
    make DESTDIR=$BUILDDIR install

    rm -rf $BUILDDIR/$prefix/mysql-test
    ln -sv mysql-$version $BUILDDIR/opt/mysql

    popd
    cleanup_src .. $srcdir
}

configure() {
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/mysql.sh << "EOF"
export MYSQL_HOME=/opt/mysql
export PATH=$PATH:$MYSQL_HOME/bin
EOF

cat > $BUILDDIR/$prefix/my.cnf << "EOF"
[client]
socket   = /run/mysqld/mysqld.sock

[mysqld]
sql_mode = NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
socket   = /run/mysqld/mysqld.sock
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: MySQL database server
 MySQL is a multi-user, multi-threaded SQL database server. MySQL is a
 client/server implementation consisting of a server daemon (mysqld) and
 many different client programs and libraries.
 .
 [Postinstallation setup]
 $ groupadd mysql
 $ useradd -r -g mysql -s /bin/false mysql
 .
 $ cd /opt/mysql
 $ chown -R mysql:mysql .
 $ scripts/mysql_install_db --user=mysql
 $ chown -R root .
 $ chown -R mysql data
 $ bin/mysqld_safe --user=mysql &
 .
 $ cp support-files/mysql.server /etc/init.d/mysql
 $ chkconfig --add mysql
EOF
}

build
