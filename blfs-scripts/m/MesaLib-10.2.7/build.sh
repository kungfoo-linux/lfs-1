#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=MesaLib-10.2.7.tar.bz2
srcdir=Mesa-10.2.7
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/MesaLib-10.2.7-add_xdemos-1.patch
patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/MesaLib-10.2.7-upstream_fixes-1.patch

./autogen.sh CFLAGS="-O2" CXXFLAGS="-O2" \
	--prefix=$XORG_PREFIX            \
	--sysconfdir=/etc                \
	--enable-texture-float           \
	--enable-gles1                   \
	--enable-gles2                   \
	--enable-openvg                  \
	--enable-osmesa                  \
	--enable-xa                      \
	--enable-gbm                     \
	--enable-gallium-egl             \
	--enable-gallium-gbm             \
	--enable-glx-tls                 \
	--with-egl-platforms="drm,x11"   \
	--with-gallium-drivers="nouveau,r300,r600,radeonsi,svga,swrast"
make
make DESTDIR=$BUILDDIR install

make -C xdemos DEMOS_PREFIX=$XORG_PREFIX
make -C xdemos DEMOS_PREFIX=$XORG_PREFIX DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-lib (>= 7.7), libdrm (>= 2.4.56), Python2 (>= 2.7.8), \
elfutils (>= 0.160), libvdpau (>= 0.8), LLVM (>= 3.5.0)
Description: an OpenGL compatible 3D graphics library
 .
 [glxgears]
 is a GL demo useful for troubleshooting graphics problems.
 .
 [glxinfo]
 is a diagnostic program that displays information about the graphics hardware
 and installed GL libraries.
 .
 [libEGL.so]
 provides a native platform graphics interface as defined by the EGL-1.4
 specification.
 .
 [libgbm.so]
 is the Mesa Graphics Buffer Manager library.
 .
 [libGLESv1_CM.so]
 is the Mesa OpenGL ES 1.1 library.
 .
 [libGLES2.so]
 is the Mesa OpenGL ES 2.0 library.
 .
 [libGL.so]
 is the main Mesa OpenGL library.
 .
 [libOpenVG.so]
 is the Mesa OpenVG 1.0 library.
 .
 [libOSMesa.so]
 is the Mesa Off-screen Rendering library.
 .
 [libxatracker.so]
 is the Xorg Gallium3D acceleration library.
EOF
}

build
