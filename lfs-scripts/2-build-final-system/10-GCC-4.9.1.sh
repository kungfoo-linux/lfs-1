#!/bin/bash -e
. ../lfs.comm

build_gcc() {
    srcfil=gcc-4.9.1.tar.bz2
    srcdir=gcc-4.9.1

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    sed -i 's/if \((code.*))\)/if (\1 \&\& \!DEBUG_INSN_P (insn))/' \
        gcc/sched-deps.c
    patch -Np1 -i $PATCHES/gcc-4.9.1-upstream_fixes-1.patch

    mkdir -v ../gcc-build && cd ../gcc-build

    SED=sed \
        ../$srcdir/configure \
        --prefix=/usr \
        --enable-languages=c,c++ \
        --disable-multilib \
        --disable-bootstrap \
        --with-system-zlib \
        --with-tune=generic
    make -j$JOBS

    # In this section, the test suite for GCC is considered critical. Do not
    # skip it under any circumstance.

    # One set of tests in the GCC test suite is known to exhaust the stack,
    # so increase the stack size prior to running the tests:
    ulimit -s 32768
    set +e
    make -j$JOBS -k check
    set -e

    # To receive a summary of the test suite results (for only the summaries,
    # pipe the output through "grep -A7 Summ"):
    ../$srcdir/contrib/test_summary

        # Following is the result on my system:
        # ---------------------------------------------
        #		=== g++ Summary ===
        # of expected passes		86373
        # of unexpected failures	16
        # of expected failures		445
        # of unsupported tests		2766
        
        #		=== gcc Summary ===
        # of expected passes		104829
        # of unexpected failures	12
        # of expected failures		248
        # of unsupported tests		1207
        
        #		=== libatomic Summary ===
        # of expected passes		44
        # of unsupported tests		5
        
        #		=== libgomp Summary ===
        # of expected passes		676
        # of unexpected failures	1
        
        #		=== libitm Summary ===
        # of expected passes		26
        # of expected failures		3
        # of unsupported tests		1
        
        #		=== libstdc++ Summary ===
        # of expected passes		9812
        # of expected failures		41
        # of unsupported tests		273
        # ---------------------------------------------

    make install
	
    # Some packages expect the C preprocessor to be installed in the /lib
    # directory. To support those packages, create this symlink:
    ln -sv ../usr/bin/cpp /lib

    # Many packages use the name cc to call the C compiler. To satisfy those
    # packages, create a symlink:
    ln -sv gcc /usr/bin/cc

    # Add a compatibility symlink to enable building programs with Link Time
    # Optimization (LTO): 
    install -v -dm755 /usr/lib/bfd-plugins
    ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/4.9.1/liblto_plugin.so \
        /usr/lib/bfd-plugins/

    # Finally, move a misplaced file:
    mkdir -pv /usr/share/gdb/auto-load/usr/lib
    mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

    cd .. && rm -rf $srcdir gcc-build
}

check() {
    # Now that our final toolchain is in place. It is important to again
    # ensure that compiling and linking will work as expected.
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
        echo 'Build gcc failed [1]'
        exit 1
    fi

    # Now make sure that we're setup to use the correct startfiles.
    result=`grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log | wc -l`
    if [ "$result" != "3" ]; then
        echo 'Build gcc failed [2]'
        exit 2
    fi

    # Verify that the compiler is searching for the correct header files.
    result=`echo \`grep -B4 '^ /usr/include' dummy.log\``
    case $(uname -m) in
      x86_64)
        machine='x86_64-unknown-linux-gnu'
        ;;
      *)
        machine='i686-pc-linux-gnu'
        ;;
    esac
    expect="#include <...> search starts here: /usr/lib/gcc/$machine/4.9.1/include /usr/local/include /usr/lib/gcc/$machine/4.9.1/include-fixed /usr/include"
    if [ "$result" != "$expect" ]; then
        echo 'Build gcc failed [3]'
        exit 3
    fi

    # Verify that the new linker is being used with the correct search paths:
    result=`echo \`grep 'SEARCH.*/usr/lib' dummy.log | sed 's|; |\n|g'\``
    case $(uname -m) in
      x86_64)
        machine='x86_64-unknown-linux-gnu'
        libdir='lib64'
        ;;
      *)
        machine='i686-pc-linux-gnu'
        libdir='lib32'
        ;;
    esac
    expect="SEARCH_DIR(\"/usr/$machine/$libdir\") SEARCH_DIR(\"/usr/local/$libdir\") SEARCH_DIR(\"/$libdir\") SEARCH_DIR(\"/usr/$libdir\") SEARCH_DIR(\"/usr/$machine/lib\") SEARCH_DIR(\"/usr/local/lib\") SEARCH_DIR(\"/lib\") SEARCH_DIR(\"/usr/lib\");"
    if [ "$result" != "$expect" ]; then
        echo 'Build gcc failed [4]'
        exit 4
    fi

    # Make sure that we're using the correct libc:
    result=`echo \`grep "/lib.*/libc.so.6 " dummy.log\``
    case $(uname -m) in
      x86_64)
        expect='attempt to open /lib64/libc.so.6 succeeded' ;;
      *)
        expect='attempt to open /lib/libc.so.6 succeeded' ;;
    esac
    if [ "$result" != "$expect" ]; then
        echo 'Build gcc failed [5]'
        exit 5
    fi

    # Lastly, make sure GCC is using the corrent dynamic linker:
    result=`echo \`grep found dummy.log\``
    case $(uname -m) in
      x86_64)
        expect='found ld-linux-x86-64.so.2 at /lib64/ld-linux-x86-64.so.2' ;;
      *)
        expect='found ld-linux.so.2 at /lib/ld-linux.so.2' ;;
    esac
    if [ "$result" != "$expect" ]; then
        echo 'Build gcc failed [6]'
        exit 6
    fi

    rm -fv dummy.c a.out dummy.log
    echo "check gcc success"
}

build_src() {
    build_gcc
    check
}

build
