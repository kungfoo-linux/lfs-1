#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=lua-5.2.3.tar.gz
srcdir=lua-5.2.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/lua-5.2.3-shared_library-1.patch
sed -i '/#define LUA_ROOT/s:/usr/local/:/usr/:' src/luaconf.h
make linux
make INSTALL_TOP=$BUILDDIR/usr \
	TO_LIB="liblua.so liblua.so.5.2 liblua.so.5.2.3" \
	INSTALL_DATA="cp -d" \
	INSTALL_MAN=$BUILDDIR/usr/share/man/man1 \
	install

mkdir -pv $BUILDDIR/usr/lib/pkgconfig
cat > $BUILDDIR/usr/lib/pkgconfig/lua.pc << "EOF"
V=5.2
R=5.2.3

prefix=/usr
INSTALL_BIN=${prefix}/bin
INSTALL_INC=${prefix}/include
INSTALL_LIB=${prefix}/lib
INSTALL_MAN=${prefix}/man/man1
INSTALL_LMOD=${prefix}/share/lua/${V}
INSTALL_CMOD=${prefix}/lib/lua/${V}
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: Lua
Description: An Extensible Extension Language
Version: ${R}
Requires: 
Libs: -L${libdir} -llua -lm
Cflags: -I${includedir}
EOF

mkdir -pv $BUILDDIR/usr/share/doc/lua-5.2.3
cp -v doc/*.{html,css,gif,png} $BUILDDIR/usr/share/doc/lua-5.2.3

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Powerful, light-weight programming language
 Lua is a powerful light-weight programming language designed for extending
 applications. It is also frequently used as a general-purpose, stand-alone
 language. Lua is implemented as a small library of C functions, written in
 ANSI C, and compiles unmodified in all known platforms. The implementation
 goals are simplicity, efficiency, portability, and low embedding cost. The
 result is a fast language engine with small footprint, making it ideal in
 embedded systems too.
 .
 [lua]
 is the standalone Lua interpreter.
 .
 [luac]
 is the Lua compiler.
 .
 [liblua.so]
 contains the Lua API functions. 
EOF
}

build
