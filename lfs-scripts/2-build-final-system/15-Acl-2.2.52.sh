#!/bin/bash -e
. ../lfs.comm

# The Acl package contains utilities to administer Access Control Lists, which
# are used to define more fine-grained discretionary access rights for files
# and directories.

build_src() {
    srcfil=acl-2.2.52.src.tar.gz
    srcdir=acl-2.2.52

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    # Modify the documentation directory so that it is a versioned directory:
    sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in

    # Fix some broken tests:
    sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test

    # Additionally, fix a bug that causes getfacl -e to segfault on overly
    # long group name:
    sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" \
        libacl/__acl_to_any_text.c

    ./configure --prefix=/usr \
        --bindir=/bin \
        --libexecdir=/usr/lib
    make -j$JOBS
    make install install-dev install-lib

    chmod -v 755 /usr/lib/libacl.so
    mv -v /usr/lib/libacl.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so

    cd .. && rm -rf $srcdir
}

build
