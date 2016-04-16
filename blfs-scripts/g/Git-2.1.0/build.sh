#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=git-2.1.0.tar.xz
srcdir=git-2.1.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

NO_TCLTK=1 NO_SVN_TESTS=1 \
./configure --prefix=/usr \
	--with-gitconfig=/etc/gitconfig \
	--with-libpcre
make
make DESTDIR=$BUILDDIR install

tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/git-manpages-2.1.0.tar.xz \
	-C $BUILDDIR/usr/share/man --no-same-owner --no-overwrite-dir

remove_perl_files
cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: cURL (>= 7.37.1), OpenSSL (>= 1.0.1i), Python2 (>= 2.7.8), \
PCRE (>= 8.35)
Description: fast, scalable, distributed revision control system
 Git is popular version control system designed to handle very large projects
 with speed and efficiency; it is used for many high profile open source
 projects, most notably the Linux kernel.
 .
 Git falls in the category of distributed source code management tools. Every
 Git working directory is a full-fledged repository with full revision
 tracking capabilities, not dependent on network access or a central server.
EOF
}

build
