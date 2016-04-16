#!/bin/bash -e
. ../lfs.comm

make_check() {
    # Now the test suite is ready to be run. First, run the tests that 
    # are meant to be run as user root:
    make NON_ROOT_USERNAME=nobody check-root

    # We're going to run the remainder of the tests as the tests as the 
    # nobody useer. Certain tests, however, require that the user be a 
    # member of more than one group. So that these are not skipped we'll 
    # add a temporary group and make a the user nobody a part of it:
    sed -i '/dummy/d' /etc/group
    echo "dummy:x:1000:nobody" >> /etc/group

    # Fix some of the permissions so that the non-root user can compile 
    # and run the tests:
    chown -Rv nobody .

    su nobody -s /bin/bash \
        -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"

    # Remove the temporary group:
    sed -i '/dummy/d' /etc/group
}

build_src() {
    srcfil=coreutils-8.23.tar.xz
    srcdir=coreutils-8.23

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    # POSIX requires that programs from Coreutils recognize character
    # boundaries correctly even in multibyte locales. The following patch
    # fixes this non-compliance and other # internationalization-related bugs.
    # In this past, many bugs were found in this patch. When reporting new
    # bugs to Coreutils maintainers, please check first if they are
    # reproducible without this patch.
    patch -Np1 -i $PATCHES/coreutils-8.23-i18n-1.patch
    touch Makefile.in

    FORCE_UNSAFE_CONFIGURE=1 \
        ./configure --prefix=/usr \
        --enable-no-install-program=kill,uptime
    make -j$JOBS

    set +e; make_check; set -e

    make install

    # Move programs to the locations specified by the FHS:
    mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
    mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
    /bin/mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
    /bin/mv -v /usr/bin/chroot /usr/sbin
    /bin/mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
    sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
    /bin/mv -v /usr/bin/{head,sleep,nice,test,[} /bin

    cd .. && /bin/rm -rf $srcdir
}

build
