#!/bin/bash -e
. ../lfs.comm

# The GCC package contains the GNU compiler collection, whick include the C
# and C++ compilers.

build_src() {
    srcfil=gcc-4.9.1.tar.bz2
    srcdir=gcc-4.9.1

    tar -xf $LFSSRC/$srcfil && cd $srcdir
    tar -xf $LFSSRC/mpfr-3.1.2.tar.xz && mv mpfr-3.1.2 mpfr
    tar -xf $LFSSRC/gmp-6.0.0a.tar.xz && mv gmp-6.0.0 gmp
    tar -xf $LFSSRC/mpc-1.0.2.tar.gz  && mv mpc-1.0.2 mpc

    for file in \
        $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
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

    # GCC doesn't detect stack protection correctly, which causes problems
    # for the build of Glibc-2.20, so fix that by issuing the following
    # command:
    sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure

    # Also fix a problem identified upstream:
    sed -i 's/if \((code.*))\)/if (\1 \&\& \!DEBUG_INSN_P (insn))/' \
        gcc/sched-deps.c

    mkdir -pv ../gcc-build && cd ../gcc-build

    ../$srcdir/configure \
        --target=$LFS_TARGET \
        --prefix=/tools \
        --with-sysroot=$LFS \
        --with-newlib \
        --with-local-prefix=/tools \
        --with-native-system-header-dir=/tools/include \
        --without-headers \
        --disable-nls \
        --disable-shared \
        --disable-multilib \
        --disable-decimal-float \
        --disable-threads \
        --disable-libatomic \
        --disable-libgomp \
        --disable-libitm \
        --disable-libquadmath \
        --disable-libsanitizer \
        --disable-libssp \
        --disable-libvtv \
        --disable-libcilkrts \
        --disable-libstdc++-v3 \
        --enable-languages=c,c++
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir gcc-build
}

build
