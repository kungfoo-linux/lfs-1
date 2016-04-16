#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=bind-9.10.0-P2.tar.gz
srcdir=bind-9.10.0-P2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --localstatedir=/var \
            --mandir=/usr/share/man \
            --enable-threads \
            --with-libtool \
            --disable-static \
            --with-randomdev=/dev/urandom
make $JOBS
make DESTDIR=$BUILDDIR install

chmod -v 0755 $BUILDDIR/usr/lib/lib{bind9,dns,isc{,cc,cfg},lwres}.so
install -v -m755 -d $BUILDDIR/usr/share/doc/bind-9.10.0-P2/{arm,misc}
install -v -m644 doc/arm/*.html $BUILDDIR/usr/share/doc/bind-9.10.0-P2/arm
install -v -m644 \
	doc/misc/{dnssec,ipv6,migrat*,options,rfc-compliance,roadmap,sdb} \
	$BUILDDIR/usr/share/doc/bind-9.10.0-P2/misc

# The rndc.conf file contains information for controlling named operations
# with the rndc utility. Generate a key for use in the named.conf and
# rdnc.conf with the rndc-confgen command:
bin/confgen/rndc-confgen -confgen -r /dev/urandom -b 512 > /tmp/rndc.conf
sed '/conf/d;/^#/!d;s:^# ::' /tmp/rndc.conf > /tmp/named.conf

cleanup_src .. $srcdir
}

configure() {
uid=20
gid=20
install -d -m770 -o $uid -g $gid $BUILDDIR/srv/named

pushd $BUILDDIR/srv/named
mkdir -p dev etc/namedb/{slave,pz} usr/lib/engines var/run/named
mknod dev/null    c 1 3
mknod dev/urandom c 1 9
chmod 666 dev/{null,urandom}
cp /etc/localtime etc
touch managed-keys.bind
cp /usr/lib/engines/libgost.so usr/lib/engines
[ $(uname -m) = x86_64 ] && ln -sv lib usr/lib64

cp /tmp/named.conf etc

# Complete the named.conf file from which named will read the location of zone
# files, root name servers and secure DNS keys:
cat >> etc/named.conf << "EOF"

// Bind 9 now logs by default through syslog (except debug).
// These are the default logging rules.

logging {
    category default { default_syslog; default_debug; };
    category unmatched { null; };

  channel default_syslog {
      syslog daemon;                      // send to syslog's daemon
                                          // facility
      severity info;                      // only send priority info
                                          // and higher
  };

  channel default_debug {
      file "named.run";                   // write to named.run in
                                          // the working directory
                                          // Note: stderr is used instead
                                          // of "named.run"
                                          // if the server is started
                                          // with the '-f' option.
      severity dynamic;                   // log at the server's
                                          // current debug level
  };

  channel default_stderr {
      stderr;                             // writes to stderr
      severity info;                      // only send priority info
                                          // and higher
  };

  channel null {
      null;                               // toss anything sent to
                                          // this channel
  };
};

options {
    directory "/etc/namedb";
    pid-file "/var/run/named.pid";
    statistics-file "/var/run/named.stats";

};

zone "." {
    type hint;
    file "root.hints";
};

zone "0.0.127.in-addr.arpa" {
    type master;
    file "pz/127.0.0";
};

// Append other DNS infomation below, e.g.:
zone "fangxm.cn" IN {
    type master;
    file "pz/fangxm.cn";
    allow-update { none; };
};
EOF

# Create zone files with the following contents:
cat > etc/namedb/pz/127.0.0 << "EOF"
$TTL 3D
@      IN      SOA     ns.local.domain. hostmaster.local.domain. (
                        1       ; Serial
                        8H      ; Refresh
                        2H      ; Retry
                        4W      ; Expire
                        1D)     ; Minimum TTL
                NS      ns.local.domain.
1               PTR     localhost.
EOF

cat > etc/namedb/pz/fangxm.cn << "EOF"
$TTL 3h  
fangxm.cn.     IN SOA ns.fangxm.cn. root@fangxm.cn (  
	       1       ; Serial  
	       3h      ; Refresh after 3 hours  
	       1h      ; Retry after 1 hour  
	       1w      ; Expire after 1 week  
	       1h )    ; Negative caching TTL of 1 hour  
 
fangxm.cn.     IN      NS   ns.fangxm.cn.  
fangxm.cn.     IN      MX   10  mail  
fangxm.cn.     IN      A    192.168.1.10
ns.fangxm.cn.  IN      A    192.168.1.10
mail           IN      A    192.168.1.10
www            IN      A    192.168.1.10
oa             IN      CNAME www  
EOF

# Create the root.hints file with the following commands (caution must be
# used to ensure there are no leading spaces in this file):
cat > etc/namedb/root.hints << "EOF"
.                       6D  IN      NS      A.ROOT-SERVERS.NET.
.                       6D  IN      NS      B.ROOT-SERVERS.NET.
.                       6D  IN      NS      C.ROOT-SERVERS.NET.
.                       6D  IN      NS      D.ROOT-SERVERS.NET.
.                       6D  IN      NS      E.ROOT-SERVERS.NET.
.                       6D  IN      NS      F.ROOT-SERVERS.NET.
.                       6D  IN      NS      G.ROOT-SERVERS.NET.
.                       6D  IN      NS      H.ROOT-SERVERS.NET.
.                       6D  IN      NS      I.ROOT-SERVERS.NET.
.                       6D  IN      NS      J.ROOT-SERVERS.NET.
.                       6D  IN      NS      K.ROOT-SERVERS.NET.
.                       6D  IN      NS      L.ROOT-SERVERS.NET.
.                       6D  IN      NS      M.ROOT-SERVERS.NET.
A.ROOT-SERVERS.NET.     6D  IN      A       198.41.0.4
B.ROOT-SERVERS.NET.     6D  IN      A       192.228.79.201
C.ROOT-SERVERS.NET.     6D  IN      A       192.33.4.12
D.ROOT-SERVERS.NET.     6D  IN      A       199.7.91.13
E.ROOT-SERVERS.NET.     6D  IN      A       192.203.230.10
F.ROOT-SERVERS.NET.     6D  IN      A       192.5.5.241
G.ROOT-SERVERS.NET.     6D  IN      A       192.112.36.4
H.ROOT-SERVERS.NET.     6D  IN      A       128.63.2.53
I.ROOT-SERVERS.NET.     6D  IN      A       192.36.148.17
J.ROOT-SERVERS.NET.     6D  IN      A       192.58.128.30
K.ROOT-SERVERS.NET.     6D  IN      A       193.0.14.129
L.ROOT-SERVERS.NET.     6D  IN      A       199.7.83.42
M.ROOT-SERVERS.NET.     6D  IN      A       202.12.27.33
EOF

# NOTE: The root.hints file is a list of root name servers. This file must be
# updated periodically with the dig utility. A current copy of root.hints can
# be obtained from ftp://rs.internic.net/domain/named.root. Consult the "BIND
# 9 Administrator Reference Manual" (http://www.bind9.net/Bv9ARM.html) for
# details.

# Set permissions on the chroot jail:
chown -R $uid:$gid $BUILDDIR/srv/named
popd

# To automatically start DNS server when the system is rebooted:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-bind
popd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenSSL (>= 1.0.1i), libxml2 (>= 2.9.1), json-c (>= 0.12), \
Net-tools (>= 20101030cvs)
Conflicts: bind (>= 9)
Description: The Berkeley Internet Name Domain (BIND) DNS server
 The Berkeley Internet Name Domain (BIND) implements an Internet domain name
 server. BIND is the most widely-used name server software on the Internet,
 and is supported by the Internet Software Consortium, www.isc.org.
 .
 [Test on local (which the machine runing the BIND server)]
 cat >> /etc/resolv.conf << "EOF"
 nameserver 127.0.0.1
 EOF
 ping fangxm.cn
 .
 [Test on other machine (which the machine installed the BIND utils)]
 cat >> /etc/resolv.conf << "EOF"
 nameserver 192.168.1.10
 EOF
 ping fangxm.cn
 .
 [Check configuration file sytax]
 named-checkconf -t /srv/named /etc/named.conf
 .
 [zone file validity]
 named-checkzone -t /srv/named "fangxm.cn" /etc/namedb/pz/fangxm.cn
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	if ! getent group "named" > /dev/null 2>&1 ; then
	    groupadd -g 20 named
	fi

	if ! getent passwd "named" > /dev/null 2>&1 ; then
	    useradd -c "BIND Owner" -g named -s /bin/false -u 20 named
	fi
	'

POSTRM_CONF_DEF='
	if getent passwd "named" > /dev/null 2>&1 ; then
	    userdel named
	fi

	if getent group "named" > /dev/null 2>&1 ; then
	    groupdel named
	fi
	'
}

build
