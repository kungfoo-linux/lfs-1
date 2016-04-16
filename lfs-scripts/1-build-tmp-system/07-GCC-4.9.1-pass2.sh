#!/bin/bash -e
. ../lfs.comm

build_gcc() {
    srcfil=gcc-4.9.1.tar.bz2
    srcdir=gcc-4.9.1

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
        `dirname $($LFS_TARGET-gcc -print-libgcc-file-name)`/include-fixed/limits.h

    for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
    do
        cp -uv $file{,.orig}
        sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
            -e 's@/usr@/tools@g' $file.orig > $file
        echo '
        #undef STANDARD_STARTFILE_PREFIX_1
        #undef STANDARD_STARTFILE_PREFIX_2
        #define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
        #define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
        touch $file.orig
    done

    tar -xf $LFSSRC/mpfr-3.1.2.tar.xz && mv mpfr-3.1.2 mpfr
    tar -xf $LFSSRC/gmp-6.0.0a.tar.xz && mv gmp-6.0.0 gmp
    tar -xf $LFSSRC/mpc-1.0.2.tar.gz  && mv mpc-1.0.2 mpc

    sed -i 's/if \((code.*))\)/if (\1 \&\& \!DEBUG_INSN_P (insn))/' \
        gcc/sched-deps.c

    mkdir -pv ../gcc-build && cd ../gcc-build

    CC=$LFS_TARGET-gcc \
        CXX=$LFS_TARGET-g++ \
        AR=$LFS_TARGET-ar \
        RANLIB=$LFS_TARGET-ranlib \
        ../$srcdir/configure \
        --prefix=/tools \
        --with-local-prefix=/tools \
        --with-native-system-header-dir=/tools/include \
        --enable-languages=c,c++ \
        --disable-libstdcxx-pch \
        --disable-multilib \
        --disable-bootstrap \
        --disable-libgomp
    make -j$JOBS
    make install
    ln -sv gcc /tools/bin/cc

    cd .. && rm -rf $srcdir gcc-build
}

check() {
    # At this point, it is imperative to stop and ensure that the basic
    # functions(compiling and linking) of the new toolchain are working
    # as expected.

    echo 'main(){}' > dummy.c	
    cc dummy.c
    result=`echo \`readelf -l a.out | grep ': /tools'\``

    case $(uname -m) in
      x86_64)
        expect='[Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]'
        ;;

      *)
        expect='[Requesting program interpreter: /tools/lib/ld-linux.so.2]'
        ;;
    esac

    if [ "$result" != "$expect" ]; then
        echo 'Build gcc pass2 failed'
        exit 1
    fi

    rm -fv dummy.c a.out
}

build_src() {
    build_gcc
    check
}

build
