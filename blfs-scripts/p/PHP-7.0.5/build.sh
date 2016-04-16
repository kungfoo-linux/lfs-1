#!/bin/bash -e
. ../../blfs.comm

prepare_dep_libxml2() {
    xml_version=2.9.3
    xml_srcfil=$BLFSSRC/l/libxml2-$xml_version/libxml2-$xml_version.tar.gz
    xml_srcdir=libxml2-$xml_version

    pushd .
    tar -xf $xml_srcfil
    cd $xml_srcdir
    
    ./configure --prefix=$PWD \
        --disable-shared \
        --without-python
    make $JOBS
    make install
    popd
}

build_src() {
    version=7.0.5
    srcfil=php-$version.tar.xz
    srcdir=php-$version
    tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
    cd $srcdir
    
    prepare_dep_libxml2
    
    prefix=/opt/php-$version
    ./configure --prefix=$prefix \
        --with-config-file-path=$prefix/etc \
        --with-config-file-scan-dir=$prefix/etc/php.d \
        --with-libxml-dir=$PWD/libxml2-2.9.3 \
        --enable-fpm \
        --enable-mysqlnd \
        --with-mysqli=mysqlnd \
        --with-pdo-mysql=mysqlnd \
        --with-mysql-sock=/run/mysqld/mysqld.sock
    make $JOBS
    make install
    install -v -m644 php.ini-production $prefix/etc/php.ini
    mv -v $prefix/etc/php-fpm.conf{.default,}
    mv -v $prefix/etc/php-fpm.d/www.conf{.default,}
    
    mkdir -pv $BUILDDIR/opt
    mv $prefix $BUILDDIR/opt
    ln -sv php-$version $BUILDDIR/opt/php
    
    cleanup_src .. $srcdir
}

configure() {
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/php.sh << "EOF"
export PHP_HOME=/opt/php
export PATH=$PATH:$PHP_HOME/bin:$PHP_HOME/sbin
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: PHP scripting language for creating dynamic web sites
 PHP is the PHP Hypertext Preprocessor. Primarily used in dynamic web sites,
 it allows for programming code to be directly embedded into the HTML markup.
 It is also useful as a general purpose scripting language.
EOF
}

build
