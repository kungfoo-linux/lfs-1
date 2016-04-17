#!/bin/bash -e
. ../../blfs.comm

prepare_dep_libxml2() {
    xml_version=2.9.3
    xml_srcfil=$BLFSSRC/l/libxml2-$xml_version/libxml2-$xml_version.tar.gz
    xml_srcdir=libxml2-$xml_version
    xml_prefix=$PWD/libxml2

    action=$1
    if [ "$action" != "true" ]; then
        return
    fi

    pushd .
    tar -xf $xml_srcfil
    cd $xml_srcdir
    
    ./configure --prefix=$xml_prefix \
        --without-python
    make $JOBS
    make install

    cp -av $xml_prefix/lib/libxml2.so* $prefix/deps
    popd
}

prepare_dep_openssl() {
    ssl_srcfil=$BLFSSRC/o/OpenSSL-1.0.1i/other-version/openssl-1.0.2f.tar.gz
    ssl_srcdir=openssl-1.0.2f
    ssl_prefix=$PWD/openssl

    action=$1
    if [ "$action" != "true" ]; then
        return
    fi

    pushd .
    tar -xf $ssl_srcfil
    cd $ssl_srcdir
    
    ./config --prefix=$ssl_prefix
    make
    make install
    popd
}

prepare_dep_curl() {
    curl_srcfil=$BLFSSRC/c/cURL-7.37.1/other-version/curl-7.48.0.tar.bz2
    curl_srcdir=curl-7.48.0
    curl_prefix=$PWD/curl

    action=$1
    if [ "$action" != "true" ]; then
        return
    fi

    pushd .
    tar -xf $curl_srcfil
    cd $curl_srcdir
    
    ./configure --prefix=$curl_prefix \
        --enable-threaded-resolver \
        --with-ssl=$ssl_prefix \
        --without-libidn \
        --without-librtmp \
        --without-libssh2 \
        --without-gssapi \
        --without-libmetalink \
        --without-libpsl \
        --without-nghttp2 \
        --disable-ldap \
        --disable-ldaps \
        --disable-rtsp \
        --disable-sspi

    make $JOBS
    make install

    cp -av $curl_prefix/lib/libcurl.so* $prefix/deps
    popd
} 

prepare_dep_mcrypt() {
    mcrypt_srcfil=$BLFSSRC/l/libmcrypt-2.5.8/libmcrypt-2.5.8.tar.bz2
    mcrypt_srcdir=libmcrypt-2.5.8
    mcrypt_prefix=$PWD/mcrypt

    action=$1
    if [ "$action" != "true" ]; then
        return
    fi

    pushd .
    tar -xf $mcrypt_srcfil
    cd $mcrypt_srcdir
    
    ./configure --prefix=$mcrypt_prefix \
        --disable-posix-threads
    make $JOBS
    make install

    cp -av $mcrypt_prefix/lib/libmcrypt.so* $prefix/deps
    popd
}

prepare_dep_gmp() {
    gmp_srcfil=$BLFSSRC/g/gmp-6.1.0/gmp-6.1.0.tar.xz
    gmp_srcdir=gmp-6.1.0
    gmp_prefix=$PWD/gmp

    action=$1
    if [ "$action" != "true" ]; then
        return
    fi

    pushd .
    tar -xf $gmp_srcfil
    cd $gmp_srcdir
    
    ./configure --prefix=$gmp_prefix
    make $JOBS
    make install

    cp -av $gmp_prefix/lib/libgmp.so* $prefix/deps
    popd
}

prepare_dep_bz2() {
    bz2_srcfil=$BLFSSRC/$PKGLETTER/$CURDIR/deps/bzip2-1.0.6.tar.gz
    bz2_srcdir=bzip2-1.0.6
    bz2_prefix=$PWD/bzip2

    action=$1
    if [ "$action" != "true" ]; then
        return
    fi

    pushd .
    tar -xf $bz2_srcfil
    cd $bz2_srcdir

    make -f Makefile-libbz2_so
    make PREFIX=$bz2_prefix install
    cp -av libbz2.so* $bz2_prefix/lib

    cp -av $bz2_prefix/lib/libbz2.so* $prefix/deps
    popd
}

prepare_dep() {
    mkdir -pv deps $prefix/deps
    pushd deps

    # pass 'true' to build, or 'false' to jump:
    prepare_dep_libxml2 true
    prepare_dep_openssl true
    prepare_dep_curl    true
    prepare_dep_mcrypt  true
    prepare_dep_gmp     true
    prepare_dep_bz2     true

    popd
}

build_src() {
    version=7.0.5
    srcfil=php-$version.tar.xz
    srcdir=php-$version
    prefix=/opt/php-$version

    prepare_dep

    tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
    cd $srcdir

    # Note:
    # 1). All '--enable-xxx' options no external libraries are needed.
    # 2). All '--with-xxx' options you can specify the external libraries
    #     position.
    # 3). For any external, you can find the install guide on site
    #     http://php.net/docs.php.

    ./configure --prefix=$prefix \
        --with-config-file-path=$prefix/etc \
        --with-config-file-scan-dir=$prefix/etc/php.d \
        --enable-fpm \
        --enable-mbstring \
        --enable-bcmath \
        --enable-ftp \
        --enable-zip \
        --enable-exif \
        --enable-mysqlnd \
        --enable-calendar \
        --enable-sysvmsg \
        --enable-sysvsem \
        --enable-sysvshm \
        --enable-wddx \
        --enable-sockets \
        --with-mysqli=mysqlnd \
        --with-pdo-mysql=mysqlnd \
        --with-mysql-sock=/run/mysqld/mysqld.sock \
        --with-libxml-dir=$xml_prefix \
        --with-openssl=$ssl_prefix \
        --with-curl=$curl_prefix \
        --with-mcrypt=$mcrypt_prefix \
        --with-gmp=$gmp_prefix \
        --with-bz2=$bz2_prefix \
        --with-zlib \
        --with-gettext

        #--with-readline
        #--with-jpeg-dir= \
        #--with-png-dir= \
        #--with-imap= \
        #--with-imap-ssl= \
        #--with-tidy= \

    # modify Makefile:
    sed -i -e "/^NATIVE_RPATHS =/ c NATIVE_RPATHS = -Wl,-rpath,$prefix/deps" \
           -e "/^PHP_RPATHS =/ c PHP_RPATHS = -Wl,-rpath,$prefix/deps" Makefile

    make $JOBS
    make install
    install -v -m644 php.ini-production $prefix/etc/php.ini
    install -v -m754 sapi/fpm/{init.d.php-fpm,php-fpm.service} $prefix/etc
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
 .
 Install php-fpm service:
 $ cp /opt/php/etc/init.d.php-fpm /etc/init.d/php-fpm
 $ chkconfig php-fpm on
 $ service php-fpm start
EOF
}

build
