#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=screen-4.2.1.tar.gz
srcdir=screen-4.2.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--infodir=/usr/share/info \
	--mandir=/usr/share/man \
	--with-socket-dir=/run/screen \
	--with-pty-group=5 \
	--with-sys-screenrc=/etc/screenrc \
	--enable-pam
sed -i -e "s%/usr/local/etc/screenrc%/etc/screenrc%" {etc,doc}/*
make
make DESTDIR=$BUILDDIR install

mkdir -pv $BUILDDIR/etc/screenrc
install -m 644 etc/etcscreenrc $BUILDDIR/etc/screenrc

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Linux-PAM (>= 1.1.8)
Description: terminal multiplexor with VT100/ANSI terminal emulation
 Screen is a terminal multiplexor that runs several separate processes,
 typically interactive shells, on a single physical character-based terminal.
 Each virtual terminal emulates a DEC VT100 plus several ANSI X3.64 and ISO
 2022 functions and also provides configurable input and output translation,
 serial port support, configurable logging, multi-user support, and many
 character encodings, including UTF-8. Screen sessions can be detached and
 resumed later on a different terminal.
 .
 [screen]
 is a terminal multiplexor with VT100/ANSI terminal emulation.
EOF
}

build
