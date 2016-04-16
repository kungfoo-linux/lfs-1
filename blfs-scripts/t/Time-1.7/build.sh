#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=time-1.7.tar.gz
srcdir=time-1.7
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i 's/$(ACLOCAL)//' Makefile.in
sed -i 's/lu", ptok ((UL) resp->ru.ru_maxrss)/ld", resp->ru.ru_maxrss/' time.c

./configure --prefix=$BUILDDIR/usr \
	--infodir=$BUILDDIR/usr/share/info
make
make install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: a GNU utility for monitoring a program's use of system resources
  The time utility is a program that measures many of the CPU resources, such
  as time and memory, that other programs use. The GNU version can format the
  output in arbitrary ways by using a printf-style format string to include
  various resource measurements.
  Although the shell has a builtin command providing similar functionalities,
  this utility is reuired by the LSB.
  .
  [time]
  reports various srtatistics about an executed command.
EOF
}

build
