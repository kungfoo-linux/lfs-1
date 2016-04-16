#!/bin/bash -e
. ../lfs.comm

check_version() {
    # list version numbers of critical development tools
    export LC_ALL=C

    bash --version | head -n1 | cut -d" " -f2-4
    echo "/bin/sh -> `readlink -f /bin/sh`"
    echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-
    bison --version | head -n1
    if [ -e /usr/bin/yacc ];
    then echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`"; 
    else echo "yacc not found"; fi
    bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-
    echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2
    diff --version | head -n1
    find --version | head -n1
    gawk --version | head -n1
    if [ -e /usr/bin/awk ];
    then echo "/usr/bin/awk -> `readlink -f /usr/bin/awk`"; 
    else echo "awk not found"; fi
    gcc --version | head -n1
    g++ --version | head -n1
    ldd --version | head -n1 | cut -d" " -f2- # glibc version
    grep --version | head -n1
    gzip --version | head -n1
    cat /proc/version
    m4 --version | head -n1
    make --version | head -n1
    patch --version | head -n1
    echo Perl `perl -V:version`
    sed --version | head -n1
    tar --version | head -n1
    xz --version | head -n1

    echo 'main(){}' > dummy.c && g++ -o dummy dummy.c
    if [ -x dummy ]
    then echo "g++ compilation OK";
    else echo "g++ compilation failed"; fi
    rm -f dummy.c dummy
}

change_to_lfs_user() {
    # verify user ID
    if [ $UID != 0 ]; then
        echo "need root user to build LFS."
        exit 1
    fi

    # add lfs group and user
    if ! getent group "lfs" > /dev/null 2>&1 ; then
        groupadd lfs
    fi

    if ! getent passwd "lfs" > /dev/null 2>&1 ; then
        useradd -s /bin/bash -g lfs -m -k /dev/null lfs
        echo lfs:admin | chpasswd
    fi

    mkdir -pv $LFS/tools $BUILDDIR
    chown -v lfs $LFS/tools $BUILDDIR
    ln -sfv $LFS/tools /
    chmod 777 /tmp

    # Setting Up the Environment
cat > /home/lfs/.bash_profile << EOF
set +h
umask 022
LFS=$LFS
LC_ALL=POSIX
#LFS_TARGET=\$(uname -m)-lfs-linux-gnu
LFS_TARGET=\$(uname -m)-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
PS1='lfs7.6 # '
export LFS LC_ALL LFS_TARGET PATH
EOF

    chown -v lfs /home/lfs/.bash_profile

    # change to user: lfs
    #su - lfs
    echo -e "\nPlease enter lfs user: \"su - lfs\"\n"
}

check_version
change_to_lfs_user
