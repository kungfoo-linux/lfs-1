#!/bin/bash -e
. ../lfs.comm

# The Sysklogd package contains programs for logging system messages, such as
# those given by the kernel when unusual things happen.

build_src() {
    srcfil=sysklogd-1.5.tar.gz
    srcdir=sysklogd-1.5

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    # Fix a problem that cause a segmentation fault under some conditions
    # in klogd:
    sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c

    make -j$JOBS
    make BINDIR=/sbin install

    cd .. && rm -rf $srcdir
}

configure() {
    # Create a new /etc/syslog.conf file by running the following:
cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
EOF
}

build
