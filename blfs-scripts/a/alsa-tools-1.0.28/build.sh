#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=alsa-tools-1.0.28.tar.bz2
srcdir=alsa-tools-1.0.28
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

rm -rf gitcompile Makefile qlo10k1 hdsploader hdspconf hdspmixer

for tool in *
do
    case $tool in
        seq)
            tool_dir=seq/sbiload
            ;;
        *)
            tool_dir=$tool
            ;;
    esac

    pushd $tool_dir
    ./configure --prefix=/usr
    make
    make DESTDIR=$BUILDDIR install
#    make install
#    /sbin/ldconfig
    popd
done
unset tool tool_dir

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: alsa-lib (>= 1.0.28), GTK+2 (>= 2.24.24), GTK+3 (>= 3.12.2)
Description: advanced tools for certain sound cards
EOF
}

build
