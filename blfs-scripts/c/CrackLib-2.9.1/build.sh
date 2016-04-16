#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=cracklib-2.9.1.tar.gz
srcdir=cracklib-2.9.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--with-default-dict=/lib/cracklib/pw_dict \
	--disable-static
make
make DESTDIR=$BUILDDIR install
mkdir -pv $BUILDDIR/lib
mv -v $BUILDDIR/usr/lib/libcrack.so.* $BUILDDIR/lib
ln -sfv ../../lib/$(readlink $BUILDDIR/usr/lib/libcrack.so) \
	$BUILDDIR/usr/lib/libcrack.so

install -v -m644 -D $BLFSSRC/$PKGLETTER/CrackLib-2.9.1/cracklib-words-20080507.gz \
	$BUILDDIR/usr/share/dict/cracklib-words.gz &&
gunzip -v $BUILDDIR/usr/share/dict/cracklib-words.gz &&
ln -v -sf cracklib-words $BUILDDIR/usr/share/dict/words &&
echo $(hostname) >> $BUILDDIR/usr/share/dict/cracklib-extra-words &&
install -v -m755 -d $BUILDDIR/lib/cracklib

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Suggests: Python2 (>= 2.7.8)
Description: pro-active password checker library
 The CrackLib package contains a library used to enforce strong passwords by
 comparing user selected passwords to words in chosen word lists.
 .
 [cracklib-check]
 is used to determine if a password is strong.
 .
 [create-cracklib-dict]
 is used to create the CrackLib dictionary from the given word list(s).
 .
 [libcrack.so]
 provides a fast dictionary lookup method for strong password enforcement.
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='
CLR_RED="\E[31m"
CLR_END="\E[0m"
'

POSTINST_CONF_DEF='
	echo "creating the CrackLib dictionary (/lib/cracklib) ..."
        create-cracklib-dict /usr/share/dict/cracklib-words \
	    /usr/share/dict/cracklib-extra-words

	echo -e $CLR_RED \
	"[Important]\n" \
	"If you are installing CrackLib after your LFS system has been\n" \
	"completed and you have the Shadow package installed, you must\n" \
	"reinstall Shadow-4.2.1 if you wish to provide strong password \n" \
	"support on your system. If you are now going to install the \n" \
	"Linux-PAM-1.1.8 package, you may disregard this note as Shadow \n" \
	"will be reinstalled after the Linux-PAM installation." \
	$CLR_END'

POSTRM_CONF_DEF='
	echo "remove the CrackLib dictionary (/lib/cracklib) ..."
	rm -rf /lib/cracklib'
}

build
