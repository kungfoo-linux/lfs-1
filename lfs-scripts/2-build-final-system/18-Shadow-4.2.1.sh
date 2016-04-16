#!/bin/bash -e
. ../lfs.comm

# The Shadow package contains programs for handling passwords in a secure way.

build_src() {
    srcfil=shadow-4.2.1.tar.xz
    srcdir=shadow-4.2.1

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    # Disable the installation of the groups program and its man pages, 
    # as Coreutils provides a better version:
    sed -i 's/groups$(EXEEXT) //' src/Makefile.in
    find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;

    # Instead of using the default crypt method, use the more secure SHA-512
    # method of password encryption, which also allows passwords longer than
    # 8 characters. It is also necessary to change the obsolete
    # /var/spool/mail location for user mailboxes that Shadow uses by default
    # to the /var/mail location used currently:
    sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
        -e 's@/var/spool/mail@/var/mail@' etc/login.defs

    # Make a minor change to make the default useradd consistent with the LFS
    # groups files:
    sed -i 's/1000/999/' etc/useradd

    # Modify the delay time from 3 seconds to zero when login failure:
    sed -i '/^FAIL_DELAY/ c FAIL_DELAY   0' etc/login.defs 

    ./configure --sysconfdir=/etc \
        --with-group-name-max-length=32
    make -j$JOBS
    make install
    mv -v /usr/bin/passwd /bin

    # To enable shadowed passwords:
    pwconv

    # To enable shadowed group passwords:
    grpconv

    # Setting the root password:
    echo root:admin | chpasswd

    cd .. && rm -rf $srcdir
}

build
