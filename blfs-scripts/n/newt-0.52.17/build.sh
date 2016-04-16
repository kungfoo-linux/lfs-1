#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=newt-0.52.17.tar.gz
srcdir=newt-0.52.17
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -e 's/^LIBNEWT =/#&/' \
    -e '/install -m 644 $(LIBNEWT)/ s/^/#/' \
    -e 's/$(LIBNEWT)/$(LIBNEWTSONAME)/g' \
    -i Makefile.in

./configure --prefix=/usr \
	--with-gpm-support
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: popt (>= 1.16), SLang (>= 2.2.4), GPM (>= 1.20.7)
Suggests: Python2 (>= 2.7.8), Python3 (>= 3.4.1)
Description: A library for text mode user interfaces
 Newt is a programming library for color text mode, widget based user
 interfaces. It can be used to add stacked windows, entry widgets, checkboxes,
 radio buttons, labels, plain text fields, scrollbars, etc., to text mode user
 interfaces. Newt is based on the S-Lang library.
EOF
}

build
