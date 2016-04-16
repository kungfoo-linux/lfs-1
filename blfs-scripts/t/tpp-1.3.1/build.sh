#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=tpp-1.3.1.tar.gz
srcdir=tpp-1.3.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv $BUILDDIR/usr/{bin,share/man/man1}
make prefix=$BUILDDIR/usr install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Ruby (>= 1.8.7), ncurses-ruby (>= 1.3.1)
Description: Text Presentation Program
 Tpp stands for text presentation program and is an ncurses-based presentation
 tool. The presentation can be written with your favorite editor in a simple
 description format and then shown on any text terminal that is supported by
 ncurses - ranging from an old VT100 to the Linux framebuffer to an xterm.
 .
 It supports color, LaTeX output of presentation, sliding in text, a command
 prompt and additional cool features.
EOF
}

build
