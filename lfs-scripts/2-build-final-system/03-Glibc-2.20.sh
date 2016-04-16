#!/bin/bash -e

. ../lfs.comm

build_glibc() {
    srcfil=glibc-2.20.tar.xz
    srcdir=glibc-2.20

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    patch -Np1 -i $PATCHES/glibc-2.20-fhs-1.patch
    mkdir -pv ../glibc-build && cd ../glibc-build

    ../$srcdir/configure \
        --prefix=/usr \
        --disable-profile \
        --enable-kernel=2.6.32 \
        --enable-obsolete-rpc
    make -j$JOBS

    # Generally a few tests do not pass, but you can generally ignore them
    set +e; make check; set -e

    touch /etc/ld.so.conf
    make install

    cp -v ../glibc-2.20/nscd/nscd.conf /etc/nscd.conf
    mkdir -pv /var/cache/nscd

    # The following instructions will install the minimum set of locales
    # necessary for the optimal coverage of tests:
    mkdir -pv /usr/lib/locale
    localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
    localedef -i de_DE -f ISO-8859-1 de_DE
    localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
    localedef -i de_DE -f UTF-8 de_DE.UTF-8
    localedef -i en_GB -f UTF-8 en_GB.UTF-8
    localedef -i en_HK -f ISO-8859-1 en_HK
    localedef -i en_PH -f ISO-8859-1 en_PH
    localedef -i en_US -f ISO-8859-1 en_US
    localedef -i en_US -f UTF-8 en_US.UTF-8
    localedef -i es_MX -f ISO-8859-1 es_MX
    localedef -i fa_IR -f UTF-8 fa_IR
    localedef -i fr_FR -f ISO-8859-1 fr_FR
    localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
    localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
    localedef -i it_IT -f ISO-8859-1 it_IT
    localedef -i it_IT -f UTF-8 it_IT.UTF-8
    localedef -i ja_JP -f EUC-JP ja_JP
    localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
    localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
    localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
    localedef -i zh_CN -f GB18030 zh_CN.GB18030
    localedef -i zh_CN -f UTF-8 zh_CN.UTF-8
    localedef -i zh_CN -f GB2312 zh_CN.GB2312

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

    # install timezone data
    tar -xf $LFSSRC/tzdata2014g.tar.gz

    ZONEINFO=/usr/share/zoneinfo
    mkdir -pv $ZONEINFO/{posix,right}

    for tz in etcetera southamerica northamerica europe africa antarctica \
        asia australasia backward pacificnew systemv; do
        zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz}
        zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
        zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
    done

    cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
    zic -d $ZONEINFO -p America/New_York
    unset ZONEINFO

    # One way to determine the local time zone, run 'tzselect'. 
    # After answering a few questions about the location, the script 
    # will output the name of the time zone (e.g., Asia/Shanghai). 
    # There are also some other possible timezones listed in 
    # /usr/share/zoneinfo such as Canada/Eastern or EST5EDT that are 
    # not identified by the script but can be used.
    # Then create the /etc/localtime file by running (replace 
    # "Asia/Shanghai" with the name of the your own time zone).
    cp -v /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

    # By default, the dynamic loader (/lib/ld-linux.so.2) searches through
    # /lib and /usr/lib for dynamic libraries that are needed by programs as
    # they are run. However, if there are libraries in directories other than
    # /lib and /usr/lib, these need to be added to the /etc/ld.so.conf file
    # in order for the dynamic loader to find them. Two directories that are
    # commonly known to contain additional libraries are /usr/local/lib and
    # /opt/lib, so add those directories to the dynamic loader's search path.
cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf

/usr/local/lib
/opt/lib
EOF

    cd .. && rm -rf $srcdir glibc-build
}

adjust_toolchain() {
    # Now that the final C libraries have been installed, it is time to
    # adjust the toolchain so that it will link any newly compiled program
    # against these new libraries.

    # First, backup the /tools linker, and replace it with the adjusted
    # linker we made in "Constructing a Temporary System". We'll also create
    # a link to its counterpart in /tools/$(gcc -dumpmachine)/bin.
    mv -v /tools/bin/{ld,ld-old}
    mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}
    mv -v /tools/bin/{ld-new,ld}
    ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld

    # Next, amend the GCC specs file so that it points to the new dynamic
    # linker. Simply deleting all instances of "/tools" should leave us with
    # the correct path to the dynamic linker. 
    # Also adjust the specs file so that GCC knows where to find the correct
    # headers and Glibc start files. A sed command accomplishes this:
    gcc -dumpspecs | sed -e 's@/tools@@g' \
        -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
        -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' > \
        `dirname $(gcc --print-libgcc-file-name)`/specs
}

check() {
    # It is imperative at this point to ensure that the basic functions
    # (compiling and linking) of the adjusted toolchain are working as
    # expected. To do this, perform the following sanity checks:
    echo 'main(){}' > dummy.c
    cc dummy.c -v -Wl,--verbose &> dummy.log
    result=`echo \`readelf -l a.out | grep ': /lib'\``

    case $(uname -m) in
        x86_64)
            expect='[Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]'
            ;;
        *)
            expect='[Requesting program interpreter: /lib/ld-linux.so.2]'
            ;;
    esac
    if [ "$result" != "$expect" ]; then
        echo 'Build glibc failed [1]'
        exit 1
    fi

    # Now make sure that we're setup to use the current startfiles:
    result=`echo \`grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log\``
    expect='/usr/lib/../lib64/crt1.o succeeded /usr/lib/../lib64/crti.o succeeded /usr/lib/../lib64/crtn.o succeeded'
    if [ "$result" != "$expect" ]; then
        echo 'Build glibc failed [2]'
        exit 2
    fi

    # Verify that the compiler is searching for the correct haader files:
    result=`echo \`grep -B1 '^ /usr/include' dummy.log\``
    expect='#include <...> search starts here: /usr/include'
    if [ "$result" != "$expect" ]; then
        echo 'Build glibc failed [3]'
        exit 3
    fi

    # Next, verify the new linker is being used with the correct search paths:
    result=`echo \`grep 'SEARCH.*/usr/lib' dummy.log | sed 's|; |\n|g'\``
    expect='SEARCH_DIR("/usr/lib") SEARCH_DIR("/lib");'
    if [ "$result" != "$expect" ]; then
        echo 'Build glibc failed [4]'
        exit 4
    fi

    # Next make sure that we're using the corrent libc:
    result=`echo \`grep "/lib.*/libc.so.6 " dummy.log\``
    case $(uname -m) in
        x86_64)
            expect='attempt to open /lib64/libc.so.6 succeeded'
            ;;
        *)
            expect='attempt to open /lib/libc.so.6 succeeded'
            ;;
    esac
    if [ "$result" != "$expect" ]; then
        echo 'Build glibc failed [5]'
        exit 5
    fi

    # Lastly, make sure GCC is using the corrent dynamic linker:
    result=`echo \`grep found dummy.log\``
    case $(uname -m) in
        x86_64)
            expect='found ld-linux-x86-64.so.2 at /lib64/ld-linux-x86-64.so.2'
            ;;
        *)
            expect='found ld-linux.so.2 at /lib/ld-linux.so.2'
            ;;
    esac
    if [ "$result" != "$expect" ]; then
        echo 'Build glibc failed [6]'
        exit 6
    fi

    rm -fv dummy.c a.out dummy.log
    echo "check success"
}

build_src() {
    build_glibc
    adjust_toolchain
    check
}

build
