#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=emacs-24.5.tar.xz
srcdir=emacs-24.5
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
    --localstatedir=/var \
    --without-jpeg \
    --without-png \
    --without-gif \
    --without-tiff \
    --without-xpm \
    --without-gnutls \
    --with-tiff=no \
    --with-sound=no \
    --with-x=no \
    --with-x-toolkit=no
make -j${jobs}
make DESTDIR=$BUILDDIR install
chown -v -R root:root $BUILDDIR/usr/share/emacs/24.5

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: GNU Emacs editor
 Emacs is a powerful, customizable, self-documenting, modeless text
 editor. Emacs contains special code editing features, a scripting
 language (elisp), and the capability to read mail, news, and more
 without leaving the editor.
EOF
}

build
