#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=llvm-3.5.0.src.tar.xz
srcdir=llvm-3.5.0.src
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/cfe-3.5.0.src.tar.xz -C tools
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/compiler-rt-3.5.0.src.tar.xz -C projects
mv tools/cfe-3.5.0.src tools/clang
mv projects/compiler-rt-3.5.0.src projects/compiler-rt

sed -e "s:/docs/llvm:/share/doc/llvm-3.5.0:" \
	-i Makefile.config.in

CC=gcc CXX=g++             \
./configure --prefix=/usr  \
	--sysconfdir=/etc  \
	--enable-libffi    \
	--enable-optimized \
	--enable-shared    \
	--disable-assertions
make
make DESTDIR=$BUILDDIR install

for file in $BUILDDIR/usr/lib/lib{clang,LLVM,LTO}*.a
do
	test -f $file && chmod -v 644 $file
done

# If you had Python-2.7.8 installed and you have built Clang, install the
# Clang Analyzer by running the following command as the root user: 
install -v -dm755 $BUILDDIR/usr/lib/clang-analyzer &&
for prog in scan-build scan-view
do
	cp -rfv tools/clang/tools/$prog $BUILDDIR/usr/lib/clang-analyzer/
	ln -sfv ../lib/clang-analyzer/$prog/$prog $BUILDDIR/usr/bin/
done &&
ln -sfv $BUILDDIR/usr/bin/clang $BUILDDIR/usr/lib/clang-analyzer/scan-build/ &&
mv -v $BUILDDIR/usr/lib/clang-analyzer/scan-build/scan-build.1 \
	$BUILDDIR/usr/share/man/man1/

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libffi (>= 3.1), Python2 (>= 2.7.8), libxml2 (>= 2.9.1)
Description: Low-Level Virtual Machine
 The LLVM package contains a collection of modular and reusable compiler and
 toolchain technologies. The Low Level Virtual Machine (LLVM) Core libraries
 provide a modern source and target-independent optimizer, along with code
 generation support for many popular CPUs (as well as some less common ones!).
 These libraries are built around a well specified code representation known
 as the LLVM intermediate representation ("LLVM IR").
 .
 The optional Clang and Compiler RT packages provide a new C, C++, Objective C
 and Objective C++ front-ends and runtime libraries for the LLVM.
 .
 [bugpoint]
 is the automatic test case reduction tool.
 .
 [clang]
 is the Clang C, C++, and Objective-C compiler.
 .
 [llc]
 is the LLVM static compiler.
 .
 [lli]
 is used to directly execute programs from LLVM bitcode.
 .
 [llvm-ar]
 is the LLVM archiver.
 .
 [llvm-as]
 is the LLVM assembler.
 .
 [llvm-bcanalyzer]
 is the LLVM bitcode analyzer.
 .
 [llvm-config]
 Prints LLVM compilation options.
 .
 [llvm-cov]
 is used to emit coverage information.
 .
 [llvm-diff]
 is the LLVM structural 'diff'.
 .
 [llvm-dis]
 is the LLVM disassembler.
 .
 [llvm-extract]
 is used to extract a function from an LLVM module.
 .
 [llvm-link]
 is the LLVM linker.
 .
 [llvm-nm]
 is used to list LLVM bitcode and object file's symbol table.
 .
 [llvm-ranlib]
 is used to generate index for LLVM archive.
 .
 [llvm-stress]
 is used to generate random .ll files.
 .
 [llvm-tblgen]
 is the LLVM Target Description To C++ Code Generator.
 .
 [opt]
 is the LLVM optimizer.
 .
 [scan-build]
 is a Perl script that invokes the Clang static analyzer.
 .
 [libLLVM-3.5.0.so]
 contains the LLVM API functions.
EOF
}

build
