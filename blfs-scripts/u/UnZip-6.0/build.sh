#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=unzip60.tar.gz
srcdir=unzip60
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

case `uname -m` in
  i?86)
    sed -i -e 's/DASM_CRC"/DASM_CRC -DNO_LCHMOD"/' unix/Makefile
    make -f unix/Makefile linux
    ;;
  *)
    sed -i -e 's/CFLAGS="-O -Wall/& -DNO_LCHMOD/' unix/Makefile
    make -f unix/Makefile linux_noasm
    ;;
esac

make prefix=$BUILDDIR/usr MANDIR=$BUILDDIR/usr/share/man/man1 install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: De-archiver for .zip files
 The UnZip package contains ZIP extraction utilities. These are useful for
 extracting files from ZIP archives. ZIP archives are created with PKZIP or
 Info-ZIP utilities, primarily in a DOS environment.
 .
 [funzip]
 allows the output of unzip commands to be redirected.
 .
 [unzip]
 lists, tests or extracts files from a ZIP archive.
 .
 [unzipfsx]
 is a self-extracting stub that can be prepended to a ZIP archive. Files in
 this format allow the recipient to decompress the archive without installing
 UnZip.
 .
 [zipgrep]
 searches files in a ZIP archive for lines matching a pattern.
 .
 [zipinfo]
 produces technical information about the files in a ZIP archive, including
 file access permissions, encryption status, type of compression, etc.
EOF
}

build
