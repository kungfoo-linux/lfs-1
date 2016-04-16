#!/bin/bash -e
. ../../blfs.comm

build_src() {
    version=1.8.1
    srcfil=nginx-$version.tar.gz
    srcdir=nginx-$version
    tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
    cd $srcdir

    tar -xf $BLFSSRC/p/PCRE-8.35/other-version/pcre-8.38.tar.bz2
    tar -xf $BLFSSRC/o/OpenSSL-1.0.1i/other-version/openssl-1.0.2f.tar.gz
    tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/deps/zlib-1.2.8.tar.xz
    
    ./configure --prefix=/opt/nginx-$version \
        --with-http_ssl_module \
        --with-pcre=./pcre-8.38 \
        --with-openssl=./openssl-1.0.2f \
        --with-zlib=./zlib-1.2.8
    make
    make DESTDIR=$BUILDDIR install
    touch $BUILDDIR/opt/nginx-$version/html/favicon.ico
    ln -sv nginx-$version $BUILDDIR/opt/nginx
    
    cleanup_src .. $srcdir
}

configure() {
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/nginx.sh << "EOF"
export PATH=$PATH:/opt/nginx/sbin
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: A high performance web server and reverse proxy server
 Nginx is a web server and a reverse proxy server for HTTP, SMTP, POP3 and
 IMAP protocols, with a strong focus on high concurrency, performance and low
 memory usage.
 .
 Add service under CentOS-7:
 --------------------------------------------------------------------
 cat > /usr/lib/systemd/system/nginx.service << "EOF"
 [Unit]
 Description=nginx - high performance web server
 Documentation=http://nginx.org/en/docs/
 After=network.target remote-fs.target nss-lookup.target
 [Service]
 Type=forking
 PIDFile=/opt/nginx/logs/nginx.pid
 ExecStart=/opt/nginx/sbin/nginx -c /opt/nginx/conf/nginx.conf 
 ExecReload=/bin/kill -s HUP $MAINPID
 ExecStop=/bin/kill -s QUIT $MAINPID
 PrivateTmp=true
 [Install]
 WantedBy=multi-user.target
 EOF
 .
 systemctl enable nginx.service
 systemctl start  nginx.service
 # or: service nginx start
 --------------------------------------------------------------------
EOF
}

build
