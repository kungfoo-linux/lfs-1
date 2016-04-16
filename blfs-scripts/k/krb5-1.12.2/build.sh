#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=krb5-1.12.2-signed.tar
srcdir=krb5-1.12.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
tar -xf krb5-1.12.2.tar.gz
cd $srcdir/src

sed -e "s@python2.5/Python.h@& python2.7/Python.h@g" \
    -e "s@-lpython2.5]@&,\n  AC_CHECK_LIB(python2.7,main,[PYTHON_LIB=-lpython2.7])@g" \
    -i configure.in
sed -e 's@\^u}@^u cols 300}@' \
    -i tests/dejagnu/config/default.exp
autoconf

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var/lib \
	--with-system-et \
	--with-system-ss \
	--with-system-verto=no \
	--enable-dns-for-realm
make
make DESTDIR=$BUILDDIR install

for LIBRARY in gssapi_krb5 gssrpc k5crypto kadm5clnt kadm5srv \
	kdb5 kdb_ldap krad krb5 krb5support verto ; do
	chmod -v 755 $BUILDDIR/usr/lib/lib$LIBRARY.so
done

mkdir -pv $BUILDDIR/{lib,bin}
mv -v $BUILDDIR/usr/lib/libkrb5.so.3*        $BUILDDIR/lib
mv -v $BUILDDIR/usr/lib/libk5crypto.so.3*    $BUILDDIR/lib
mv -v $BUILDDIR/usr/lib/libkrb5support.so.0* $BUILDDIR/lib

ln -v -sf ../../lib/libkrb5.so.3.3        $BUILDDIR/usr/lib/libkrb5.so
ln -v -sf ../../lib/libk5crypto.so.3.1    $BUILDDIR/usr/lib/libk5crypto.so
ln -v -sf ../../lib/libkrb5support.so.0.1 $BUILDDIR/usr/lib/libkrb5support.so

mv -v $BUILDDIR/usr/bin/ksu $BUILDDIR/bin
chmod -v 755 $BUILDDIR/bin/ksu

install -v -dm755 $BUILDDIR/usr/share/doc/krb5-1.12.2
cp -vfr ../doc/*  $BUILDDIR/usr/share/doc/krb5-1.12.2
unset LIBRARY

cleanup_src ../.. $srcdir
rm -f krb5-1.12.2.tar.gz.asc
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: xxx
Description: The Kerberos network authentication system
 MIT Kerberos V5 is a free implementation of Kerberos 5. Kerberos is a network
 authentication protocol. It centralizes the authentication database and uses
 kerberized applications to work with servers or services that support
 Kerberos allowing single logins and encrypted communication over internal
 networks or the Internet.
EOF
}

build
